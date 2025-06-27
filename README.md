### Key Points
- **Standard ECS Metrics**: The `CPUUtilization` metric for Amazon ECS clusters and services is available at a 1-minute resolution in CloudWatch.
- **Container Insights**: Provides task and container-level metrics, likely at 1-minute resolution, but raw log data may allow finer granularity via CloudWatch Logs Insights.
- **High-Resolution Metrics**: To achieve 1-second data points for ECS CPU utilization, custom metrics must be published, or for ECS on EC2, the CloudWatch Agent can be configured to collect container metrics at 1-second intervals.
- **ECS on Fargate Limitation**: High-resolution metrics are not directly available; custom metrics from applications are required.
- **Retention and Cost**: High-resolution metrics (below 60 seconds) are retained for 3 hours and incur higher costs compared to standard metrics.

### Overview
Amazon CloudWatch collects metrics for Amazon ECS, including `CPUUtilization`, at a standard 1-minute resolution. To obtain 1-second data points for ECS CPU utilization, you can use high-resolution custom metrics. For ECS on EC2, this can be achieved by configuring the CloudWatch Agent to collect container metrics at 1-second intervals. For ECS on Fargate, you must publish custom metrics from your application. High-resolution metrics are retained for 3 hours and come with additional costs.

### Setup for ECS on EC2
To collect 1-second CPU utilization metrics for containers in ECS on EC2, deploy the CloudWatch Agent on your EC2 instances and configure it to collect Docker metrics at a 1-second interval. This setup publishes high-resolution custom metrics to CloudWatch.

### Setup for ECS on Fargate
Since Fargate is serverless, you cannot deploy the CloudWatch Agent. Instead, instrument your application to publish custom metrics using the AWS SDK, specifying a 1-second storage resolution.

### Pricing and Retention
High-resolution metrics (1-second data points) are retained for 3 hours before being aggregated to 1-minute periods. These metrics incur higher charges than standard metrics. Check the [Amazon CloudWatch Pricing](https://aws.amazon.com/cloudwatch/pricing/) page for details.

---



# Amazon CloudWatch Metrics for ECS CPU Utilization

This documentation addresses the collection of Amazon ECS CPU utilization metrics in CloudWatch, focusing on achieving 1-second data points, including setup instructions, retention periods, and pricing details.

## Standard ECS Metrics

Amazon ECS provides metrics in the `AWS/ECS` namespace, including `CPUUtilization`, which measures the percentage of CPU units used by clusters or services.

- **Metric Name**: `CPUUtilization`
- **Namespace**: `AWS/ECS`
- **Dimensions**: `ClusterName`, `ServiceName`
- **Description**: 
  - **Cluster-level**: Total CPU units used by ECS tasks divided by total CPU units for registered EC2 instances (EC2 launch type only).
  - **Service-level**: Total CPU units used by tasks in the service divided by total CPU units reserved for those tasks (EC2 and Fargate).
- **Resolution**: 1 minute
- **Retention Period**: 
  - 60-second data points: 15 days
  - 300-second (5-minute) data points: 63 days
  - 3600-second (1-hour) data points: 455 days (15 months)
- **Cost**: Included with ECS service usage, no additional charge for standard metrics.

**Note**: Metrics are only sent for resources with tasks in the `RUNNING` state.

## Container Insights Metrics

CloudWatch Container Insights provides detailed metrics for ECS clusters, services, tasks, and containers, available in the `ECS/ContainerInsights` namespace. These metrics are charged as custom metrics.

- **Key Metrics**:
  - `TaskCpuUtilization`: CPU utilization percentage for a task.
  - `ContainerCpuUtilization`: CPU utilization percentage for a container.
  - Other metrics include `MemoryUtilized`, `MemoryReserved`, `NetworkRxBytes`, `NetworkTxBytes`, etc.
- **Dimensions**: `ClusterName`, `ServiceName`, `TaskId`, `TaskDefinitionFamily`, `ContainerName`, etc.
- **Resolution**: Likely 1 minute for aggregated metrics, though raw performance log events may allow finer granularity via CloudWatch Logs Insights.
- **Retention Period**: 
  - 60-second data points: 15 days
  - 300-second data points: 63 days
  - 3600-second data points: 455 days
- **Cost**: Charged as custom metrics. See [Amazon CloudWatch Pricing](https://aws.amazon.com/cloudwatch/pricing/).

**Enhanced Observability**: Released on December 2, 2024, Container Insights with enhanced observability provides granular metrics and curated dashboards for ECS on EC2 and Fargate. However, documentation does not explicitly confirm sub-60-second resolution for these metrics.

## High-Resolution Metrics (Below 60 Seconds)

To achieve 1-second data points for ECS CPU utilization, you must use high-resolution custom metrics, which have a storage resolution of 1 second. This is not available for standard ECS or Container Insights metrics, which are typically at 1-minute resolution.

### Retention Period for High-Resolution Metrics
- **1-second to 30-second periods**: Retained for 3 hours.
- **Aggregated to 60-second periods**: Retained for 15 days.
- **Further aggregations**: 300-second data points for 63 days, 3600-second data points for 455 days.

### Pricing for High-Resolution Metrics
- High-resolution custom metrics incur higher charges than standard metrics.
- **Cost Example**: Based on CloudWatch pricing, custom metrics are approximately $0.30 per metric per month, with high-resolution metrics (1-second to 30-second periods) charged at a higher rate due to increased data points.
- Refer to [Amazon CloudWatch Pricing](https://aws.amazon.com/cloudwatch/pricing/) for detailed pricing.

## Setup for 1-Second CPU Utilization Metrics

### ECS on EC2
To collect 1-second CPU utilization metrics for containers, deploy the CloudWatch Agent on EC2 instances hosting your ECS cluster.

1. **Install the CloudWatch Agent**:
   - Follow the [installation guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-EC2-Instance.html) to install the agent on your EC2 instances.
   - Ensure the EC2 instances have the necessary IAM permissions, including `cloudwatch:PutMetricData` and `logs:PutLogEvents`.

2. **Configure the Agent**:
   - Create or edit the CloudWatch Agent configuration file (e.g., `/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json`).
   - Include the `docker` plugin to collect container metrics with a 1-second interval.
   - Example configuration:
     ```json
     {
       "metrics": {
         "append_dimensions": {
           "InstanceId": "${aws:InstanceId}"
         },
         "metrics_collected": {
           "docker": {
             "measurement": [
               "cpu_usage",
               "memory_usage"
             ],
             "metrics_collection_interval": 1
           }
         }
       }
     }
     ```
   - Use the [configuration wizard](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file-wizard.html) or manually edit the JSON file.

3. **Start the Agent**:
   - Start the CloudWatch Agent service: `sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/path/to/config.json -s`.
   - The agent publishes metrics to CloudWatch in the `CWAgent` namespace with a storage resolution of 1 second.

4. **Verify Metrics**:
   - In the CloudWatch console, navigate to Metrics > All metrics > CWAgent to view the `cpu_usage` metric for containers.
   - Metrics are available with periods of 1, 5, 10, 30 seconds, or multiples of 60 seconds.

### ECS on Fargate
Since Fargate is serverless, you cannot deploy the CloudWatch Agent. Instead, instrument your application to publish custom metrics with 1-second resolution.

1. **Instrument Your Application**:
   - Use the AWS SDK (e.g., Boto3 for Python) to publish CPU utilization metrics.
   - Example Python code to publish a custom metric:
     ```python
     import boto3
     from datetime import datetime

     def get_cpu_utilization():
         # Implement logic to retrieve CPU utilization (e.g., from container runtime or application)
         return 75.0  # Placeholder value

     cloudwatch = boto3.client('cloudwatch')

     cloudwatch.put_metric_data(
         Namespace='MyCustomMetrics',
         MetricData=[{
             'MetricName': 'CPUUtilization',
             'Dimensions': [
                 {'Name': 'TaskId', 'Value': 'your-task-id'},
                 {'Name': 'ClusterName', 'Value': 'your-cluster-name'}
             ],
             'Timestamp': datetime.utcnow(),
             'Value': get_cpu_utilization(),
             'Unit': 'Percent',
             'StorageResolution': 1
         }]
     )
     ```
   - Ensure your application has access to CPU utilization data, which may require container runtime APIs or system calls.

2. **IAM Permissions**:
   - Attach an IAM role to your ECS task with permissions for `cloudwatch:PutMetricData`.

3. **Verify Metrics**:
   - In the CloudWatch console, navigate to Metrics > All metrics > MyCustomMetrics to view the `CPUUtilization` metric.
   - Select a 1-second period to view high-resolution data points.

## Using CloudWatch Logs Insights for Finer Granularity
Container Insights collects performance log events in a structured JSON format, stored in the `/aws/ecs/containerinsights/ClusterName/performance` log group. These logs may contain CPU utilization data at a finer granularity (e.g., 5 or 10 seconds), depending on the collection frequency.

- **Query Example**:
  ```plaintext
  fields @timestamp, CpuUtilized, TaskId
  | filter Type = "Task"
  | sort @timestamp desc
  | limit 100
  ```
- **Steps**:
  1. Open the CloudWatch console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/).
  2. Navigate to Logs > Logs Insights.
  3. Select the `/aws/ecs/containerinsights/ClusterName/performance` log group.
  4. Run a query to extract CPU utilization data, specifying a time range (e.g., 1 minute) to approximate 1-second granularity if log events are frequent.

**Note**: The exact frequency of log events is not explicitly documented but is typically 5–10 seconds. This approach provides raw data rather than aggregated metrics, which may not fully meet the requirement for CloudWatch metrics at 1-second resolution.

## Limitations
- **Fargate**: No direct support for high-resolution metrics without custom application instrumentation.
- **Cost**: High-resolution metrics increase costs due to higher data point frequency.
- **Retention**: Limited to 3 hours for 1-second data points, requiring timely analysis or export.

## Recommendations
- For **ECS on EC2**, use the CloudWatch Agent with a 1-second collection interval for container-level CPU metrics.
- For **ECS on Fargate**, implement custom metric publishing within your application.
- Use Container Insights with enhanced observability for detailed dashboards and consider querying performance logs for finer-grained data.
- Monitor costs closely, as high-resolution metrics can significantly increase CloudWatch expenses.

## Pricing Details
The following table summarizes CloudWatch pricing relevant to ECS metrics:

| **Metric Type**            | **Cost**                              | **Notes**                                                                 |
|----------------------------|---------------------------------------|---------------------------------------------------------------------------|
| Standard ECS Metrics        | Free                                  | Included with ECS service usage.                                          |
| Container Insights Metrics  | ~$0.30 per metric per month           | Charged as custom metrics; varies by region.                               |
| High-Resolution Metrics     | Higher than standard custom metrics   | Charged per `PutMetricData` call; see [pricing page](https://aws.amazon.com/cloudwatch/pricing/). |
| Logs Insights Queries       | Varies based on data scanned          | Charged per GB of data scanned; see [pricing page](https://aws.amazon.com/cloudwatch/pricing/). |

## Conclusion
Achieving 1-second data points for ECS CPU utilization requires custom solutions:
- **ECS on EC2**: Configure the CloudWatch Agent to collect container metrics at 1-second intervals.
- **ECS on Fargate**: Publish custom metrics from your application using the AWS SDK.
Standard ECS and Container Insights metrics are at 1-minute resolution, but performance logs may offer finer granularity via CloudWatch Logs Insights. Be mindful of the 3-hour retention period for high-resolution metrics and the associated costs.



### Key Citations
- [Monitor Amazon ECS using CloudWatch](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cloudwatch-metrics.html)
- [Amazon ECS Container Insights metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-metrics-ECS.html)
- [Publish custom metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html)
- [CloudWatch agent configuration](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)
- [Amazon CloudWatch Pricing](https://aws.amazon.com/cloudwatch/pricing/)
- [Amazon CloudWatch introduces High-Resolution Custom Metrics](https://aws.amazon.com/about-aws/whats-new/2017/07/amazon-cloudwatch-introduces-high-resolution-custom-metrics-and-alarms/)
- [New – High-Resolution Custom Metrics for Amazon CloudWatch](https://aws.amazon.com/blogs/aws/new-high-resolution-custom-metrics-and-alarms-for-amazon-cloudwatch/)
- [Use CloudWatch Container Insights to monitor Amazon ECS](https://repost.aws/knowledge-center/cloudwatch-container-insights-ecs)
- [Container Insights with enhanced observability now available in Amazon ECS](https://aws.amazon.com/blogs/aws/container-insights-with-enhanced-observability-now-available-in-amazon-ecs/)
- [Amazon CloudWatch Container Insights launches enhanced observability for Amazon ECS](https://aws.amazon.com/about-aws/whats-new/2024/12/amazon-cloudwatch-container-insights-observability-ecs/)
- [Introducing Amazon CloudWatch Container Insights for Amazon ECS](https://aws.amazon.com/blogs/mt/introducing-container-insights-for-amazon-ecs/)
- [CloudWatch Container Insights for Amazon EKS Clusters](https://www.kloia.com/blog/cloudwatch-container-insights-for-amazon-eks-clusters)
- [Amazon Elastic Container Service (ECS) using Container Insights and CloudWatch](https://help.sumologic.com/docs/integrations/amazon-aws/elastic-container-service-container-insights-cloudwatch/)
- [AWS Container Insights metric collection retention period](https://www.reddit.com/r/aws/comments/xcdewm/container_insights_metric_collection_retention/)
- [Monitor ECS with CloudWatch Container Insights](https://aws.amazon.com/awstv/watch/188a1e29807/)
- [AWS high resolution metrics for faster ECS scaling](https://stackoverflow.com/questions/63299977/aws-high-resolution-metrics-for-faster-ecs-scaling)
- [Easily Monitor Containerized Applications with Amazon CloudWatch Container Insights](https://community.aws/content/2dr8ECO7VZXJwpew6b5gzs1F6Wh/navigating-amazon-eks-eks-monitor-containerized-applications?lang=en)
- [AWS Adds Container Insights with Enhanced Observability to Elastic Container Service](https://www.infoq.com/news/2025/01/aws-container-insights-ecs/)
- [Has anyone gone all in on CloudWatch Container Insights with Enhanced Observability?](https://www.reddit.com/r/devops/comments/1byhz45/has_anyone_gone_all_in_on_cloudwatch_container/)
