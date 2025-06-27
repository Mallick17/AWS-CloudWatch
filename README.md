# Collecting High-Resolution (1-Second) CPU Utilization Metrics for ECS on EC2
Amazon CloudWatch collects metrics for Amazon ECS, including `CPUUtilization`, at a standard 1-minute resolution. To obtain 1-second data points for ECS CPU utilization, you can use high-resolution custom metrics. For ECS on EC2, this can be achieved by configuring the CloudWatch Agent to collect container metrics at 1-second intervals. For ECS on Fargate, you must publish custom metrics from your application. High-resolution metrics are retained for 3 hours and come with additional costs.

To collect CPU utilization metrics at 1-second resolution for containers running on Amazon ECS with the EC2 launch type, the CloudWatch Agent is the recommended approach. This setup allows you to monitor Docker container metrics with high granularity, publishing them as custom metrics to Amazon CloudWatch. Below are the detailed steps and considerations:

## Key Points
- **Standard ECS Metrics Limitation**: The default `CPUUtilization` metric in the `AWS/ECS` namespace is available at 1-minute resolution, insufficient for 1-second granularity.
- **Container Insights**: Provides task and container-level metrics in the `ECS/ContainerInsights` namespace, typically at 1-minute resolution. For finer granularity, high-resolution custom metrics are required.
- **High-Resolution Metrics**: Achieved by configuring the CloudWatch Agent on EC2 instances to collect container metrics at 1-second intervals, stored with 1-second resolution in CloudWatch.
- **ECS on Fargate Limitation**: Fargate does not support the CloudWatch Agent; custom metric publishing from applications is needed for high-resolution metrics.
- **Retention**: 1-second data points are retained for 3 hours, then aggregated to coarser resolutions over time.
- **Cost**: Involves custom metric charges ($0.30/month beyond the first 10 free metrics) and API request costs ($0.01/1,000 requests beyond 1M free requests/month), mitigated by agent batching.

---
## Amazon CloudWatch Metrics for ECS CPU Utilization
### Standard ECS Metrics

Amazon ECS provides metrics in the `AWS/ECS` namespace, including `CPUUtilization`, which measures the percentage of CPU units used by clusters or services.

<details>
  <summary>Click to View Standard ECS Metrics</summary>

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

</details>

**Note**: Metrics are only sent for resources with tasks in the `RUNNING` state.

### Container Insights Metrics

CloudWatch Container Insights provides detailed metrics for ECS clusters, services, tasks, and containers, available in the `ECS/ContainerInsights` namespace. These metrics are charged as custom metrics.

<details>
  <summary>Click to View Container Insights Metrics</summary>
  
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

</details>

**Enhanced Observability**: Released on December 2, 2024, Container Insights with enhanced observability provides granular metrics and curated dashboards for ECS on EC2 and Fargate. However, documentation does not explicitly confirm sub-60-second resolution for these metrics.

### High-Resolution Metrics (Below 60 Seconds)

To achieve 1-second data points for ECS CPU utilization, you must use high-resolution custom metrics, which have a storage resolution of 1 second. This is not available for standard ECS or Container Insights metrics, which are typically at 1-minute resolution.

## Setup Instructions for ECS on EC2
1. **Install the CloudWatch Agent**:
   - Deploy the agent on EC2 instances hosting your ECS cluster. Follow the [official AWS installation guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-EC2-Instance.html).
   - Ensure EC2 instances have an IAM role with permissions including `cloudwatch:PutMetricData` and `logs:PutLogEvents`.

2. **Configure the Agent**:
   - Edit the CloudWatch Agent configuration file (e.g., `/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json`).
   - Use the `docker` plugin to collect container metrics, setting `metrics_collection_interval` to 1 second for CPU utilization.
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
               "cpu_usage"
             ],
             "metrics_collection_interval": 1
           }
         }
       }
     }
     ```
   - Optionally, use the [configuration wizard](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file-wizard.html) to generate this file.

3. **Start the Agent**:
   - Launch the agent with the configuration file using the command:
     ```bash
     sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/path/to/config.json -s
     ```
   - This starts the agent in EC2 mode, publishing metrics to CloudWatch.

4. **Verify Metrics**:
   - In the CloudWatch console, go to **Metrics > All metrics > CWAgent**.
   - Look for the `cpu_usage` metric under the `CWAgent` namespace, tagged with dimensions like `InstanceId`.
   - Select a 1-second period to confirm high-resolution data points are available for the last 3 hours.

---

## Retention Period
High-resolution metrics follow this retention schedule:
- **1-second resolution**: Retained for 3 hours, ideal for real-time analysis.
- **1-minute resolution**: Aggregated after 3 hours, retained for 15 days.
- **5-minute resolution**: Retained for 63 days after 15 days.
- **1-hour resolution**: Retained for 455 days (15 months) for long-term trends.
For continuous 30-day collection, only the most recent 3 hours of data are available at 1-second resolution at any time, with older data aggregated.

<details>
   <summary>Retention period Analysis</summary>

#### Retention Period Analysis
The retention period for CloudWatch metrics varies based on the resolution, with high-resolution metrics having a shorter initial retention due to their granularity. Research from AWS documentation and FAQs indicates the following retention schedule:

| **Resolution** | **Retention Period** | **Notes** |
|----------------|----------------------|-----------|
| 1 second       | 3 hours             | High-resolution custom metrics, available for real-time analysis. |
| 1 minute       | 15 days             | Aggregated after 3 hours, for short-term detailed analysis. |
| 5 minutes      | 63 days             | After 15 days, for medium-term trends. |
| 1 hour         | 455 days (15 months)| After 63 days, for long-term analysis. |

- **1-second data points (high-resolution, <60 seconds)**: Retained for 3 hours. This is supported by the AWS CloudWatch FAQs, which state, "The retention period is 15 months per metric data point with automatic roll up (<60secs available for 3 hours, one min available for 15 days, 5 min available for 63 days, one hour available for 15 months)" ([APM Tool - Amazon CloudWatch FAQs - AWS](https://aws.amazon.com/cloudwatch/faqs/)).

- **1-minute data points (60-second period)**: Retained for 15 days after aggregation from high-resolution data.

- **5-minute data points (300-second period)**: Retained for 63 days, applicable after the 15-day period for 1-minute data.

- **1-hour data points (3600-second period)**: Retained for 455 days (15 months), covering long-term analysis needs.

This retention schedule is consistent across multiple sources, including a Stack Overflow discussion and AWS news blogs, confirming that high-resolution metrics are available at 1-second resolution for only 3 hours before being rolled up to standard resolutions for longer retention ([Amazon CloudWatch Update – Extended Metrics Retention & User Interface Update | AWS News Blog](https://aws.amazon.com/blogs/aws/amazon-cloudwatch-update-extended-metrics-retention-user-interface-update/), [CloudWatch extends Metrics retention and new User Interface](https://aws.amazon.com/about-aws/whats-new/2016/11/cloudwatch-extends-metrics-retention-and-new-user-interface/)).

For the user's 30-day collection period, the 1-second data points would be accessible for the first 3 hours of each collection, with subsequent data aggregated and retained as per the schedule above. This means detailed, second-by-second analysis is limited to the most recent 3 hours, while longer-term trends can be analyzed at coarser resolutions.

</details>

---

## Cost Considerations
Costs for high-resolution metrics depend on:
- **Custom Metrics**: First 10 metrics are free per month; additional metrics cost $0.30 each per month.
- **API Requests (PutMetricData)**: First 1,000,000 requests are free per month; additional requests cost $0.01 per 1,000.
- **Batching**: The CloudWatch Agent batches metrics, sending ~60 data points (1 minute’s worth) per call, typically every minute, reducing API request frequency to 43,200 calls per metric per 30 days (60 calls/hour * 24 hours * 30 days).

#### Cost Table for 30 Days at 1-Second Resolution
The table below estimates costs for collecting high-resolution CPU utilization metrics over 30 days, assuming continuous 1-second data points sent to CloudWatch via the agent:

| Number of Metrics | API Calls (30 days) | Calls Beyond Free Tier (1M) | API Cost (USD) | Metric Cost (USD) | Total Cost (USD) |
|-------------------|---------------------|-----------------------------|----------------|-------------------|------------------|
| 1                 | 43,200              | 0                           | $0.00          | $0.00             | $0.00            |
| 5                 | 216,000             | 0                           | $0.00          | $0.00             | $0.00            |
| 10                | 432,000             | 0                           | $0.00          | $0.00             | $0.00            |
| 11                | 475,200             | 0                           | $0.00          | $0.30             | $0.30            |
| 24                | 1,036,800           | 36,800                      | $0.37          | $4.20             | $4.57            |
| 50                | 2,160,000           | 1,160,000                   | $11.60         | $12.00            | $23.60           |
| 100               | 4,320,000           | 3,320,000                   | $33.20         | $27.00            | $60.20           |

**Assumptions**:
- Each metric generates 2,592,000 data points over 30 days (30 * 24 * 60 * 60 = 2,592,000 seconds).
- The CloudWatch Agent batches data, sending approximately 43,200 `PutMetricData` calls per metric per month (one call per minute, each with 60 data points).
- First 10 custom metrics and 1,000,000 API calls per month are free.
- Additional metrics cost $0.30 each per month; additional API calls cost $0.01 per 1,000.

| **Cost Component** | **Pricing** | **Notes** |
|--------------------|-------------|-----------|
| Custom Metrics     | $0.30 per metric per month | First 10 custom metrics free per month. Volume pricing for >10,000 metrics: $0.10 for next 240,000, $0.05 for next 750,000, $0.02 for over 1,000,000 metrics. |
| API Requests (PutMetricData) | First 1,000,000 requests free per month, then $0.01 per 1,000 requests | CloudWatch agent batches metrics, typically resulting in one API call per minute per metric. For N metrics, approximately N * 43,200 requests per month. |

<details>
   <summary>Cost Calculation Analysis</summary>

#### Cost Calculation for 30 Days at 1-Second Intervals
The pricing for high-resolution metrics involves two main components: the cost of custom metrics and the cost of API requests for publishing data. The evidence leans toward the following structure based on official AWS pricing and documentation:

##### Custom Metrics Cost
Custom metrics, including high-resolution ones, are charged per metric per month, with the following tiers:
- First 10 custom metrics are free per month, covering both standard and detailed monitoring metrics.
- Beyond the free tier, the first 10,000 metrics cost $0.30 each per month, with volume discounts for larger volumes:
  - Next 240,000 metrics (10,001 to 250,000): $0.10 each.
  - Next 750,000 metrics (250,001 to 1,000,000): $0.05 each.
  - Over 1,000,000 metrics: $0.02 each.

Importantly, pricing for high-resolution metrics is identical to standard resolution metrics, as confirmed in a 2017 AWS News Blog post: "Pricing for high-resolution metrics is identical to that for standard resolution metrics, with volume tiers that can help you to realize savings when you use large numbers of metrics" ([New – High-Resolution Custom Metrics and Alarms for Amazon CloudWatch | AWS News Blog](https://aws.amazon.com/blogs/aws/new-high-resolution-custom-metrics-and-alarms-for-amazon-cloudwatch/)). This means the per-metric cost does not increase for high resolution, focusing the additional cost potential on API requests.

For example, if monitoring 15 high-resolution metrics for ECS CPU utilization (5 beyond the free tier), the metric cost would be (5 * $0.30) = $1.50 per month, assuming within the first 10,000 metrics.

##### API Requests Cost
Publishing metrics to CloudWatch involves the PutMetricData API call, with the following pricing:
- First 1,000,000 API requests per month are free, excluding certain calls like GetMetricData, which are always charged.
- Beyond the free tier, it's $0.01 per 1,000 requests, as seen in pricing examples ([Amazon CloudWatch Pricing – Amazon Web Services (AWS)](https://aws.amazon.com/cloudwatch/pricing/)).

The frequency of PutMetricData calls is critical, especially for high-resolution metrics collected every second. However, the CloudWatch agent is designed to batch metrics to optimize costs, with a default `force_flush_interval` of 60 seconds, meaning metrics are buffered and sent every minute ([Manually create or edit the CloudWatch agent configuration file - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)). For a metric collected every second, this results in 60 data points sent in one API call every minute, aligning with standard metrics for publication frequency.

For instance, for one high-resolution metric:
- Number of API calls per month: 60 calls per hour * 24 hours * 30 days = 43,200 calls.
- Since 43,200 is less than 1,000,000, it falls within the free tier, incurring no additional cost.

For 100 metrics, it would be 4,320,000 calls monthly, exceeding the free tier by 3,320,000 calls. The additional cost would be (3,320,000 / 1,000) * $0.01 = $33.20 per month for API requests, plus the metric cost of 100 * $0.30 = $30.00 (first 10 free, next 90 at $0.30), totaling $63.20 per month.

##### Batching and Cost Optimization
The CloudWatch agent's batching mechanism is crucial for cost management. Each PutMetricData call can include up to 1,000 data points or 40 KB, whichever is smaller, and for metrics, it's typically the data point limit that matters. By collecting metrics every second and publishing every minute, the agent sends 60 data points per call, well within the limit, ensuring minimal API calls. This aligns with AWS's advice to optimize costs by reducing the frequency of API calls, as noted in documentation on reducing CloudWatch charges ([Analyzing, optimizing, and reducing CloudWatch costs - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_billing.html)).

For high-resolution metrics, if published individually every second without batching, the cost could escalate significantly. For example, publishing one data point per second for one metric would result in 2,592,000 calls per month (86,400 seconds/day * 30 days), exceeding the free tier by 1,592,000 calls, costing (1,592,000 / 1,000) * $0.01 = $15.92 per month for API requests alone, plus $0.30 for the metric, totaling $16.22. However, the agent's default behavior mitigates this by batching, making the practical cost align with standard metrics for similar publication frequencies.

</details>

---

#### Practical Implications for 30-Day Collection at 1-Second Intervals
For the user's specific case, collecting high-resolution metrics continuously at 1-second intervals for 30 days, the setup involves configuring the CloudWatch agent with a `metrics_collection_interval` of 1 second for relevant metrics like CPU utilization. The agent will collect data every second and batch it, likely sending every 60 seconds, resulting in costs similar to standard metrics. For example, monitoring 5 containers with one CPU utilization metric each (total 5 metrics beyond the free tier):
- Metric cost: 5 * $0.30 = $1.50 per month.
- API requests: 5 * 43,200 = 216,000 calls, within the free tier, so no additional cost.
- Total: $1.50 per month.

For larger deployments, ensure to monitor API call volumes to avoid exceeding the free tier, especially as the number of metrics scales. The retention period ensures that 1-second data is available for the first 3 hours, suitable for real-time monitoring, with longer-term analysis possible at coarser resolutions.

---

#### Background on High-Resolution Metrics
High-resolution metrics in Amazon CloudWatch are defined as having a granularity of 1 second, compared to the standard 1-minute resolution for metrics produced by AWS services. When publishing custom metrics, users can specify either standard or high resolution by setting the `StorageResolution` parameter to 1 in the PutMetricData API request, enabling storage and retrieval at 1-second intervals ([Publish custom metrics - Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html)). This is particularly useful for monitoring dynamic environments where rapid changes, such as ECS CPU utilization, need immediate visibility.

---
## Additional Notes
- **Monitoring Costs**: Regularly check CloudWatch usage in the AWS Billing Dashboard to ensure API calls stay within the free tier, especially for larger deployments.
- **Enhanced Observability**: Container Insights with enhanced observability (released December 2, 2024) offers detailed dashboards but does not guarantee sub-60-second resolution without custom setup.
- **Logs Insights Alternative**: For raw data, query performance logs in `/aws/ecs/containerinsights/ClusterName/performance` via CloudWatch Logs Insights, though this is typically at 5–10-second intervals, not 1-second metrics.





<details>
  <summary>ECS on Fargate & CloudWatch Logs Insights for Finer Granularity & Key Citations</summary>

### ECS on Fargate
Since Fargate is serverless, you cannot deploy the CloudWatch Agent. Instead, instrument your application to publish custom metrics with 1-second resolution.

<details>
  <summary>Click to view Fargate Serverless Configuration</summary>

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

</details>

2. **IAM Permissions**:
   - Attach an IAM role to your ECS task with permissions for `cloudwatch:PutMetricData`.

3. **Verify Metrics**:
   - In the CloudWatch console, navigate to Metrics > All metrics > MyCustomMetrics to view the `CPUUtilization` metric.
   - Select a 1-second period to view high-resolution data points.


---

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
- [Publish custom metrics Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html)
- [New High-Resolution Custom Metrics Alarms Amazon CloudWatch AWS News Blog](https://aws.amazon.com/blogs/aws/new-high-resolution-custom-metrics-and-alarms-for-amazon-cloudwatch/)
- [Amazon CloudWatch Pricing Amazon Web Services AWS](https://aws.amazon.com/cloudwatch/pricing/)
- [CloudWatch Metrics Pricing Explained Plain English](https://www.vantage.sh/blog/cloudwatch-metrics-pricing-explained-in-plain-english)
- [Analyzing optimizing reducing CloudWatch costs Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_billing.html)
- [APM Tool Amazon CloudWatch FAQs AWS](https://aws.amazon.com/cloudwatch/faqs/)
- [Amazon CloudWatch Update Extended Metrics Retention User Interface Update AWS News Blog](https://aws.amazon.com/blogs/aws/amazon-cloudwatch-update-extended-metrics-retention-user-interface-update/)
- [CloudWatch extends Metrics retention new User Interface](https://aws.amazon.com/about-aws/whats-new/2016/11/cloudwatch-extends-metrics-retention-and-new-user-interface/)
- [Manually create edit CloudWatch agent configuration file Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)

</details>
