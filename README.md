# Amazon CloudWatch
- Amazon CloudWatch is a monitoring and observation service that is built for DevOps Engineers, developers, security engineers and IT managers.
- CloudWatch provides you with data and actionable insights to monitor your applications, respond to system-wide performance changes, and optimize resource utilization. You get a unified view of operational health.
---

## CloudWatch Logs

**Overview and Fundamentals:**
Amazon CloudWatch Logs enables monitoring, storing, and accessing log files from AWS resources such as Amazon EC2 instances, AWS Lambda functions, and AWS CloudTrail. It centralizes logs from systems, applications, and AWS services in a scalable service, offering features for viewing, searching, filtering, archiving logs securely, and querying with a powerful query language. Logs are divided into two classes: Standard (full features) and Infrequent Access (lower ingestion charges, subset of Standard capabilities). For details, see [What is Amazon CloudWatch Logs?](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html).

**Creating and Configuring Log Groups:**

- **Creation Methods:** Log groups can be created via the AWS Management Console, AWS CLI, or during CloudWatch Logs agent installation on EC2 instances. To create via console, navigate to [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/), select Log groups, choose Actions > Create log group, enter a name, and create. CLI command example: `aws logs create-log-group --log-group-name MyLogGroup`.
- **Retention Settings:** Default retention is indefinite, adjustable between 10 years and 1 day. Change via console: Select log group, choose Actions > Edit retention setting, set period (e.g., 30 days). Takes up to 72 hours for log events to delete after reaching retention.
- **Tagging:** Add tags during creation or later, with a maximum of 50 tags per log group. Use AWS CLI commands like `aws logs tag-resource` for tagging, with key restrictions (1-128 Unicode characters, values 0-255, cannot start with "aws:"). See [Working with log groups and log streams](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html) for CLI and API details.

**Setting Up Log Streams:**

- A log stream is a sequence of log events sharing the same source, belonging to one log group, with no limit on the number of streams per group. Automatically received from AWS services or sent using methods like the CloudWatch Logs agent or SDKs. For EC2, install the agent as an RPM (e.g., `sudo yum install -y awslogs` for Amazon Linux), ensuring logs are sent to the specified log stream.

**Searching and Filtering Log Data:**

- **Console Search:** View logs by navigating to [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/), selecting Log groups, choosing a group and stream, and using the search field for filtering. Specify time ranges (Absolute or Relative, e.g., last 24 hours) and switch between UTC and local time zone.
- **CloudWatch Logs Insights:** Use for interactive search and analysis, with a query language, sample queries, autocompletion, and field discovery. Create field indexes to improve query performance and reduce scan volume. Use Live Tail for near real-time viewing, filtering, and highlighting of ingested logs. See [Analyzing log data with CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html) for query examples.

**Example:**
To create a log group with 30-day retention using AWS CLI:
```bash
aws logs create-log-group --log-group-name MyLogGroup --retention-in-days 30
```

---

## CloudWatch Metrics
**Overview and Concepts:**
CloudWatch Metrics are time-ordered data points representing the performance of AWS systems, kept for 15 months for historical analysis. Default metrics are provided free for resources like EC2 instances, EBS volumes, and RDS DB instances, with options for detailed monitoring or publishing custom metrics. See [Metrics in Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html).

**AWS Services Supported by CloudWatch Metrics:**

A comprehensive list includes services like AWS Amplify, Amazon API Gateway, Amazon Aurora (under AWS/RDS namespace), and many others. Below is a partial table for clarity:

| Service                              | Namespace                          | Documentation                                                                 |
|--------------------------------------|------------------------------------|------------------------------------------------------------------------------|
| Amazon EC2                           | AWS/EC2                            | [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch.html) |
| Amazon RDS                           | AWS/RDS                            | [https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.AuroraMySQL.Monitoring.Metrics.html](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.AuroraMySQL.Monitoring.Metrics.html) |
| Amazon S3                            | AWS/S3                             | [https://docs.aws.amazon.com/AmazonS3/latest/userguide/cloudwatch-monitoring.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/cloudwatch-monitoring.html) |
| AWS Lambda                           | AWS/Lambda                         | [https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html) |

For a complete list, refer to [AWS services that publish CloudWatch metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html).

**Custom Metrics:**
Publish custom metrics as standard (1-minute resolution) or high resolution (1-second, higher charge). Use `aws cloudwatch put-metric-data` for CLI, e.g.:
```bash
aws cloudwatch put-metric-data --namespace MyNamespace --metric-name MyMetric --value 42
```


## CloudWatch Alarms: States, Thresholds, and Actions
**Overview and Alarm States:**
CloudWatch Alarms monitor a single metric or expression, with possible states: `OK` (within threshold), `ALARM` (outside threshold), `INSUFFICIENT_DATA` (alarm just started, metric unavailable, or insufficient data). See [Using Amazon CloudWatch alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html).

**Setting Thresholds:**

- **Period:** Length of time (seconds) to evaluate metric/expression for each data point, e.g., 300 seconds (5 minutes). For high-resolution alarms, can be 10s, 20s, 30s (higher charge); regular alarms use multiples of 60s.
- **Evaluation Periods:** Number of recent periods/data points to evaluate, e.g., 2 periods.
- **Datapoints to Alarm:** Number of breaching data points within Evaluation Periods to trigger `ALARM`, not consecutive, must be within last Evaluation Periods. For periods ≥1 minute, evaluated every minute; multi-day alarms (>1 day) evaluated hourly.
- **Percentile Alarms:** Setting used when <10/(1-percentile) data points for percentiles 0.5–1.0, or <10/percentile for 0–0.5, e.g., <1000 samples for p99.

**Actions:**

- Triggered on state transitions (except Auto Scaling, invoked once/minute in new state). Supported actions include sending Amazon SNS notifications, EC2 actions (stop, terminate, reboot, recover), Auto Scaling actions, starting Amazon Q investigations, and creating Systems Manager OpsItems/incidents.
- Composite alarms can send SNS notifications, create investigations/OpsItems/incidents, but not EC2/Auto Scaling actions.
- Lambda actions are asynchronous, with retries if failed; require resource policy (e.g., CLI: `aws lambda add-permission` with principal `lambda.alarms.cloudwatch.amazonaws.com`).
- EventBridge integration: Alarms emit events, trigger actions; see [What is Amazon EventBridge?](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html).
- Missing data treatment options: `notBreaching`, `breaching`, `ignore`, `missing` (default `missing`); DynamoDB metrics always ignore missing data.

**Example:**
Create an alarm for high CPU utilization:
```bash
aws cloudwatch put-metric-alarm --alarm-name HighCPUAlarm --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 80 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value=i-1234567890abcdef0 --evaluation-periods 2 --alarm-actions arn:aws:sns:us-east-1:123456789012:MyTopic
```

#### CloudWatch Events (Amazon EventBridge): Targets and Actions

**Overview and Fundamentals:**
Amazon EventBridge, formerly CloudWatch Events, is a serverless event bus service for connecting applications using events, enabling event-driven architectures. Events represent state changes or occurrences, routed via rules to targets. See [What Is Amazon EventBridge?](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html).

**Targets and Actions for Event Rules:**

- **Event Rules:** Specify what EventBridge does with events delivered to event buses. Two types: match on event data (event pattern) or run on schedule. Event pattern defines structure and fields to match, e.g., EC2 state changes. Schedule rules use cron or rate expressions, now recommended via EventBridge Scheduler for scalability. See [Creating rules that react to events in Amazon EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-rule.html).
- **Targets:** Event buses deliver to zero or more targets; Pipes deliver to a single target. Common targets include AWS Lambda functions, Amazon SQS queues, Amazon SNS topics, and more. Pipes support advanced transformations and enrichment prior to delivery.
- **Actions:** Actions are the invocation of targets, such as running a Lambda function, sending an SNS notification, or triggering an SQS message. EventBridge can create necessary IAM roles for permissions, e.g., for Lambda targets.

**Example:**
Create a rule to trigger Lambda on EC2 state change:
```bash
aws events put-rule --name EC2StateChangeRule --event-pattern "{\"source\":[\"aws.ec2\"],\"detail-type\":[\"EC2 Instance State-change Notification\"]}"
aws events put-targets --rule EC2StateChangeRule --targets "Id"="1","Arn"="arn:aws:lambda:us-east-1:123456789012:function:MyFunction"
```

---

## Pricing

CloudWatch pricing is usage-based, with a free tier for initial usage. Details include:

- **Metrics:** Free for basic metrics from AWS services; custom metrics cost per metric per month, with high-resolution metrics (1-second) incurring higher charges. See [Publish custom metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html).
- **Logs:** Charges based on data ingested (GB), archived (GB-month), and analyzed (queries). Standard logs have full features; Infrequent Access logs lower ingestion charges. See [Amazon CloudWatch Pricing](https://aws.amazon.com/cloudwatch/pricing/).
- **Alarms:** Cost per alarm per month, with a free tier limit. High-resolution alarms (10s, 30s periods) have additional charges.
- **Dashboards:** Per dashboard per month for viewing metrics, with charges for API requests and data transfer.
- **Events:** Charges based on events published, rules invoked, and targets processed, with EventBridge Scheduler costs for scheduled invocations.

For exact rates, consult the [AWS CloudWatch Pricing page](https://aws.amazon.com/cloudwatch/pricing/).


---

## Terraform with CloudWatch

**Overview:**
Terraform, an infrastructure as code tool, enables programmatic management of CloudWatch resources. Use the AWS provider for resources like `aws_cloudwatch_log_group`, `aws_cloudwatch_metric_alarm`, and `aws_cloudwatch_event_rule`. See [Terraform AWS Provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).

**Examples:**

- **Log Group:**
```hcl
resource "aws_cloudwatch_log_group" "example" {
  name              = "MyLogGroup"
  retention_in_days = 30
}
```
- **Metric Alarm:**
```hcl
resource "aws_cloudwatch_metric_alarm" "example" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors EC2 CPU utilization"
  dimensions = {
    InstanceId = "i-1234567890abcdef0"
  }
  alarm_actions = ["arn:aws:sns:us-east-1:123456789012:MyTopic"]
}
```
- **Event Rule:** Similar to CLI, define rules and targets in HCL for consistency and versioning.

Best practices include avoiding hardcoded values, using variables for dynamic configurations, and regularly updating Terraform versions for compatibility.

---

### What problem does CloudWatch solve?
Amazon CloudWatch solves the problem of responding to events and alarms, as they occur in your architecture. 
- Amazon CloudWatch collects monitoring and operational data in the form of logs, metrices, and events. It provides you with a unified view of AWS resources, applications and services that run on AWS and on-premises servers.
- You can use CloudWatch to detect anomalous behaviour in your environments, set alarms, and visualize logs and metrics side by side. Use it to take automated actions, toubleshoot issues, and discover insights to keep your applicatipns running smoothly.

### Benefits of CloudWatch
- You can use CloudWatch to collect metrics and logs from all your AWS resources, applications, and services that run on AWS and on-premises servers. You can monitor them from one platform.
- You can use CloudWatch to maintain visibility across your services, applications, and infrastructure, so you can visualize key metrics like CPU utilization and memory.
- You can use CloudWatch to set alarms and take automated actions. It frees up important resources so you can focus on adding business value.

### How can I architect a cloud solution using CloudWatch?
We can architect a solution by using Amazon CloudWatch to monitor the CPU utilization and take action.

![image](https://github.com/user-attachments/assets/9b13e2f4-68d0-46fb-b4ae-2f3e49bc4fe4)

- In the diagram, CloudWatch receives data on the EC2 instance CPU utilization. When the CPU goes over a specified percent, CloudWatch triggers Amazon EC2 Auto Scaling to provision an additional instance to help with the workload. Therefore, the first instance isn’t overloaded.

### How can I use CLoudWatch?
1. **Application Monitoring**
   - CloudWatch can monitor your applications that run on AWS (on Amazon EC2, containers, and serverless) or on-premises. CloudWatch collects data at every layer of the performance stack, including metrics and logs on automatic dashboards.  

2. **Proactive Resource Optimization**
   - CloudWatch alarms watch your metric values against thresholds that you specify, or that CloudWatch creates by using machine learning models to detect anomalous behavior. For example, if an alarm is triggered, CloudWatch can take action automatically to enable Amazon EC2 Auto Scaling or stop an instance. In this way, you can automate capacity and resource planning.  

3. **Infrastructure Monitoring and Troubleshooting**:  
   - You can use CloudWatch to monitor key metrics and logs, visualize your application and infrastructure stack, and create alarms. It correlates metrics and logs to understand and resolve the root cause of performance issues in your AWS resources.  

### What else should I keep in Mind when using CloudWatch?
Some services provide basic CloudWatch monitoring at no additional charge with the option to upgrade to detailed monitoring, which comes with a charge.

For example, EC2 instances, by default, are enabled with basic CloudWatch monitoring. Thus, data is available automatically in 5-minute periods. If you decide to upgrade to detailed CloudWatch monitoring on your instances, data is available in 1-minute periods instead of 5-minute periods.

### How much does CloudWatch cost?
Amazon CloudWatch does not require an upfront commitment or minimum fee; you pay for what you use. You are charged at the end of the month for your usage.

Amazon CloudWatch charges you for alarms, custom events, metrics collection, and dashboards that you set up. However, you can get started with Amazon CloudWatch for free. Most AWS services (Amazon EC2, Amazon S3, Amazon Kinesis, and others) send metrics automatically for free to CloudWatch. Many applications should be able to operate within these free tier limits.

<details>
   <summary>Additional AWS Services and Their Use Cases in CloudWatch</summary>

### Additional AWS Services and Their Use Cases

1. **Amazon Simple Queue Service (SQS):**
   - **Use Case:** Queue alarm notifications for processing by other applications.
   - **Integration:** Configure an SNS topic to send messages to an SQS queue, which can be polled by a Lambda function or worker application.
   - **Benefit:** Decouples notification handling, allowing asynchronous processing.

2. **Amazon Simple Email Service (SES):**
   - **Use Case:** Customize email content beyond SNS default templates.
   - **Integration:** Use SES as a subscription endpoint for SNS or trigger SES directly via Lambda for branded emails.
   - **Benefit:** Offers advanced email formatting and tracking (e.g., delivery status).

3. **Amazon CloudTrail:**
   - **Use Case:** Log alarm state changes for auditing.
   - **Integration:** Enable CloudTrail to capture CloudWatch API calls (e.g., `PutMetricAlarm`) and store them in S3.
   - **Benefit:** Provides a compliance and troubleshooting trail.

4. **Amazon Step Functions:**
   - **Use Case:** Orchestrate complex workflows triggered by alarms.
   - **Integration:** Use EventBridge to start a Step Functions state machine that coordinates Lambda, SNS, and other services.
   - **Benefit:** Automates multi-step incident response (e.g., notify team, scale resources, log incident).

5. **Amazon DynamoDB:**
   - **Use Case:** Store alarm history or metadata.
   - **Integration:** Use a Lambda function triggered by the alarm to write data to a DynamoDB table.
   - **Benefit:** Enables long-term storage and querying of alarm events.

6. **Amazon Simple Storage Service (S3):**
   - **Use Case:** Archive alarm data or logs.
   - **Integration:** Configure a Lambda function to upload alarm details to an S3 bucket.
   - **Benefit:** Provides durable storage for historical analysis.
   
</details>

---

## CloudWatch Log Group Metric Filter
A **metric filter** is a tool that scans log data as it is sent to a CloudWatch Logs log group, looks for specific patterns or terms, and then extracts numerical data from those logs to publish as a **CloudWatch metric**.

*   **Purpose:** Transform log events into numerical time-series data that can be graphed, monitored, and alarmed upon.
*   **Scope:** Assigned to a log group and applied to all log streams within that group.
*   **Key Difference from Logs Insights:** Metric filters are for continuously creating metrics. Logs Insights is for interactive, on-demand querying of log data.

---

### How Metric Filters Work

1.  **Pattern Matching:** You define a filter pattern (e.g., `ERROR`, `{ $.eventType = "Delete" }`).
2.  **Incrementing the Metric:** Each time a log event matches the pattern, the filter increments a corresponding metric.
3.  **Value Assignment:** You can configure the metric to be incremented by a static value (e.g., `1` for a simple count) or by a dynamic value extracted from the log event itself (e.g., a `latency` value).
4.  **Aggregation:** CloudWatch aggregates and reports these metric values every minute.

---

### Core Concepts & Configuration

#### 1. Filter Pattern Syntax

Metric filters use a common pattern syntax also used by subscription filters. Patterns can be simple terms or complex expressions using operators.

**Examples:**
*   `ERROR` - Matches any log event containing the word "ERROR".
*   `"AccessDenied"` - Matches the exact phrase.
*   `[w1=ERROR, w2=AccessDenied]` - Matches structured logs where the first field is "ERROR" and the second is "AccessDenied".
*   `{ $.eventType = "UpdateTrail" }` - Matches a JSON log where the `eventType` key has the value "UpdateTrail".
*   `ERROR || Exception` - Matches events containing "ERROR" OR "Exception".
*   `ERROR && RequestId` - Matches events containing both "ERROR" AND "RequestId".

#### 2. Configuring the Metric Value

When creating a filter, you define two key numerical values:

*   **Metric Value:** The value added to the metric when a log event **matches** the filter pattern.
    *   Can be a static number (e.g., `1` to count occurrences).
    *   Can be a value extracted from the log event using a variable like `$.latency`.
*   **Default Value (Highly Recommended):** The value reported for the metric when the filter finds **no matches** in a one-minute period.
    *   Prevents "spotty" metrics and ensures more accurate data aggregation.
    *   A default value of `0` is typical for counting metrics.
    *   **Note:** You cannot specify a default value if you are publishing dimensions.

**Example:** If your application sends 10 logs per minute:
*   With `Metric Value = 1` and `Default Value = 0`:
    *   **Minute 1:** 7 matches -> Metric value = **7**
    *   **Minute 2:** 0 matches -> Metric value = **0** (the default)

#### 3. Publishing Dimensions

**Dimensions** are name/value pairs that act as metadata for a metric, allowing you to segment and filter your metric data.

*   **Availability:** Only supported for **JSON** and **space-delimited** log events.
*   **Limit:** Up to **3 dimensions** per metric filter.
*   **⚠️ Cost Warning:** Dimensions create unique metric permutations. Using high-cardinality fields (like `requestID`, `ipAddress`) can lead to a massive number of unique metrics and **significant unexpected charges**. Use low-cardinality fields like `environment`, `service`, or `errorType`.

**How to Define a Dimension:**
You map a name to a field extracted by your filter pattern.

*   **JSON Example:**
    *   **Log:** `{ "eventType": "UpdateTrail", "sourceIP": "123.123.123.123" }`
    *   **Filter Pattern:** `{ $.eventType = "*" }`
    *   **Dimension:** `"EventType" : $.eventType`
    *   **Result:** A metric with a dimension `EventType=UpdateTrail`.

*   **Space-Delimited Example:**
    *   **Log:** `127.0.0.1 Prod frank [10/Oct/2000:13:25:15 -0700] "GET /index.html HTTP/1.0" 404 1534`
    *   **Filter Pattern:** `[ip, server, username, timestamp, request, status_code, bytes > 1000]`
    *   **Dimension:** `"Server" : $server`
    *   **Result:** A metric with a dimension `Server=Prod`.

#### 4. Extracting Values from Log Events

Instead of a static increment, you can extract a numerical value from the log event itself to use as the metric value. This is powerful for measuring things like latency, packet loss, or dollar amounts reported in logs.

**Syntax:** `metricValue: <extracted_field>`

**Example: Measuring Latency from a JSON Log**
*   **Log Event:**
    ```json
    {
      "latency": 50,
      "requestType": "GET"
    }
    ```
*   **Filter Pattern:** `{ $.latency = * }`
*   **Metric Value:** `$.latency`
*   **Result:** The filter matches the log and publishes a value of **50** to the CloudWatch metric.

---

### Key Points & Best Practices

1.  **Assign to Log Groups:** Filters are created on a per-log-group basis.
2.  **Default Value:** **Always set a Default Value** (usually `0`) to ensure consistent metric reporting, even during periods with no matching events.
3.  **Unit of Measure:** Assign the correct unit (e.g., `Seconds`, `Bytes`, `Count`) when creating the filter. Changing it later may not work as expected.
4.  **Dimensions & Cost:** Be extremely cautious with dimensions. Avoid high-cardinality fields to prevent excessive costs and potential automatic disabling of the filter by AWS.
5.  **Billing Alarm:** Create a **billing alarm** in CloudWatch to get notified of unexpected charges, which can sometimes be caused by misconfigured metric filters.

---

### Summary: Steps to Create a Metric Filter

1.  **Access CloudWatch Logs:** Open the CloudWatch console and navigate to **Logs > Log groups**.
2.  **Select Log Group:** Choose the target log group.
3.  **Initiate Creation:** Choose **Actions > Create metric filter**.
4.  **Define Pattern:** Enter your filter pattern (e.g., `ERROR`, `{ $.errorCode = "*" }`).
5.  **Test Pattern:** Use the test feature to validate it against sample log data.
6.  **Configure Metric:**
    *   Provide a **Metric Name** and **Namespace**.
    *   Set the **Metric Value** (static number or variable from log).
    *   **(Recommended)** Set a **Default Value** (e.g., `0`).
    *   **(Optional)** Add up to 3 **Dimensions** by mapping names to fields.
7.  **Create Filter:** Finish the process. The metric will begin appearing in your CloudWatch metrics shortly.


---

# [CloudWatch Cost](https://aws.amazon.com/cloudwatch/pricing/)
- **Metrics Cost:** You pay monthly for the number of unique metrics monitored, here 2 metrics at $0.30 each.
- **High Resolution Metrics:** Pricing is same per metric regardless of data frequency, but you pay more if you send metrics every second (high resolution). Your current 60 sec interval is standard resolution, so no high resolution charge applies unless you reduce interval.
- **API Costs:** API cost is for sending/fetching metric data. You send 60 API calls per hour which sums about 43,200 calls per month. Priced at $0.01 per 1,000 requests, resulting in about $0.44/month.

## AWS provides a free tier every month (reset monthly):
- _Basic monitoring metrics_ from AWS services (e.g., EC2 CPU utilization, S3 request counts): Completely free, no limits on volume.
- _Custom/detailed monitoring metrics:_ First 10 metrics per month free.
- _API requests (e.g., GetMetricData calls):_ First 1 million free per month (excludes some like GetMetricData, which are always charged).
- _Alarms:_ Up to 10 standard alarms on basic metrics free.
> This covers many small workloads, but with thousands of metrics, you'll likely exceed it and pay tiered rates.

<details>
    <summary>Click to view few Metrics Free for AWS Services</summary>

### Free Basic AWS Service Metrics in CloudWatch

Yes, as mentioned, basic monitoring metrics from AWS services are **completely free**—no charges for ingestion, storage, or retrieval under the standard resolution (typically 5-minute intervals). These are automatically published to CloudWatch for resources like instances, buckets, databases, etc. Detailed monitoring (1-minute intervals) or custom metrics beyond the free tier (10 custom metrics/month) incur costs.

Nearly **all AWS services that support CloudWatch integration** provide basic free metrics. According to the official AWS documentation, over 100 services publish them, including EC2, S3, RDS, Lambda, DynamoDB, and more. Basic monitoring is enabled by default and free for all supported services.

#### Full List of AWS Services with Free Basic Metrics
Here's a comprehensive table of services (extracted from AWS docs). All have basic monitoring enabled and free by default. For detailed metrics per service, follow the provided links.

| Service | Basic Free? | Example Basic Metrics | Details Link |
|---------|-------------|-----------------------|--------------|
| AWS Amplify | Yes | App-level requests, errors | [Link](https://docs.aws.amazon.com/amplify/latest/userguide/access-logs.html) |
| Amazon API Gateway | Yes | Cache hit/miss, latency | [Link](https://docs.aws.amazon.com/apigateway/latest/developerguide/monitoring-cloudwatch.html) |
| Amazon AppFlow | Yes | Flow runs, errors | [Link](https://docs.aws.amazon.com/appflow/latest/userguide/monitoring-cloudwatch.html) |
| AWS Application Migration Service | Yes | Replication jobs, lag | [Link](https://docs.aws.amazon.com/mgn/latest/ug/monitoring-cloudwatch.html) |
| AWS App Runner | Yes | CPU/memory utilization | [Link](https://docs.aws.amazon.com/apprunner/latest/dg/monitor-cw.html) |
| AppStream 2.0 | Yes | Fleet utilization | [Link](https://docs.aws.amazon.com/appstream2/latest/developerguide/monitoring.html) |
| AWS AppSync | Yes | Resolver invocations | [Link](https://docs.aws.amazon.com/appsync/latest/devguide/monitoring.html#cw-metrics) |
| Amazon Athena | Yes | Query execution time | [Link](https://docs.aws.amazon.com/athena/latest/ug/query-metrics-viewing.html) |
| Amazon Aurora | Yes | CPU, connections (RDS subset) | [Link](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.AuroraMySQL.Monitoring.Metrics.html) |
| AWS Backup | Yes | Backup jobs completed | [Link](https://docs.aws.amazon.com/aws-backup/latest/devguide/cloudwatch.html) |
| Amazon Bedrock Guardrails | Yes | Evaluation counts | [Link](https://docs.aws.amazon.com/bedrock/latest/userguide/monitoring-guardrails-cw-metrics.html) |
| AWS Billing and Cost Management | Yes | Estimated charges | [Link](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/monitor-charges.html) |
| Amazon Braket | Yes | Task runtime | [Link](https://docs.aws.amazon.com/braket/latest/developerguide/braket-monitor-metrics.html) |
| AWS Certificate Manager | Yes | Certificate requests | [Link](https://docs.aws.amazon.com/acm/latest/userguide/cloudwatch-metrics.html) |
| AWS Private CA | Yes | Certificate issuances | [Link](https://docs.aws.amazon.com/privateca/latest/userguide/PcaCloudWatch.html) |
| Amazon Q Developer in chat applications | Yes | Chat sessions | [Link](https://docs.aws.amazon.com//chatbot/latest/adminguide/monitoring-cloudwatch.html) |
| Amazon Chime | Yes | Call duration | [Link](https://docs.aws.amazon.com/chime/latest/ag/monitoring-cloudwatch.html) |
| Amazon Chime SDK | Yes | Meeting participants | [Link](https://docs.aws.amazon.com/chime-sdk/latest/dg/service-metrics.html) |
| AWS Client VPN | Yes | Connection attempts | [Link](https://docs.aws.amazon.com//vpn/latest/clientvpn-admin/monitoring-cloudwatch.html) |
| Amazon CloudFront | Yes | Requests, bytes downloaded | [Link](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/monitoring-using-cloudwatch.html) |
| AWS CloudHSM | Yes | HSM utilization | [Link](https://docs.aws.amazon.com/cloudhsm/latest/userguide/hsm-metrics-cw.html) |
| Amazon CloudSearch | Yes | Search requests | [Link](https://docs.aws.amazon.com/cloudsearch/latest/developerguide/cloudwatch-monitoring.html) |
| AWS CloudTrail | Yes | Event deliveries | [Link](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-lake-cloudwatch-metrics.html) |
| CloudWatch agent | Yes | System metrics (CPU, etc.) | [Link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html) |
| CloudWatch Application Signals | Yes | App health scores | [Link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AppSignals-MetricsCollected.html) |
| CloudWatch metric streams | Yes | Stream successes | [Link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-metric-streams-monitoring.html) |
| CloudWatch RUM | Yes | Page load times | [Link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-metrics.html) |
| CloudWatch Synthetics | Yes | Canary successes | [Link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries_metrics.html) |
| Amazon CloudWatch Logs | Yes | Log group storage | [Link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatch-Logs-Monitoring-CloudWatch-Metrics.html) |
| AWS CodeBuild | Yes | Build durations | [Link](https://docs.aws.amazon.com/codebuild/latest/userguide/monitoring-builds.html) |
| Amazon CodeGuru Reviewer | Yes | Code reviews | [Link](https://docs.aws.amazon.com/codeguru/latest/reviewer-ug/monitoring.html) |
| AWS CodePipeline | Yes | Pipeline executions | [Link](https://docs.aws.amazon.com/codepipeline/latest/userguide/metrics-dimensions.html) |
| Amazon Kendra | Yes | Query counts | [Link](https://docs.aws.amazon.com/kendra/latest/dg/cloudwatch-metrics.html) |
| Amazon Cognito | Yes | Sign-in attempts | [Link](https://docs.aws.amazon.com/cognito/latest/developerguide/monitoring.html) |
| Amazon Comprehend | Yes | Document processing | [Link](https://docs.aws.amazon.com/comprehend/latest/dg/manage-endpoints-monitor.html) |
| AWS Config | Yes | Config rule evaluations | [Link](https://docs.aws.amazon.com/config/latest/developerguide/viewing-the-aws-config-dashboard.html#aws-config-dashboard-metrics) |
| Amazon Connect | Yes | Contact queues | [Link](https://docs.aws.amazon.com/connect/latest/adminguide/monitoring-cloudwatch.html) |
| Amazon Data Lifecycle Manager | Yes | Policy executions | [Link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/monitor-dlm-cw-metrics.html) |
| AWS DataSync | Yes | Transfer bytes | [Link](https://docs.aws.amazon.com/datasync/latest/userguide/monitor-datasync.html) |
| Amazon DataZone | Yes | Domain projects | [Link](https://docs.aws.amazon.com/datazone/latest/userguide/monitoring-cloudwatch.html) |
| Amazon DevOps Guru | Yes | Insight severities | [Link](https://docs.aws.amazon.com/devops-guru/latest/userguide/monitoring-cloudwatch.html) |
| AWS Database Migration Service | Yes | Replication lag | [Link](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Monitoring.html) |
| AWS Direct Connect | Yes | Connection bandwidth | [Link](https://docs.aws.amazon.com/directconnect/latest/UserGuide/monitoring-cloudwatch.html) |
| AWS Directory Service | Yes | Directory size | [Link](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_deploy_additional_dcs.html#scaledcs) |
| Amazon DocumentDB | Yes | CPU, connections | [Link](https://docs.aws.amazon.com//documentdb/latest/developerguide/cloud_watch.html) |
| Amazon DynamoDB | Yes | Read/write capacity | [Link](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/metrics-dimensions.html) |
| DynamoDB Accelerator (DAX) | Yes | Cache hits | [Link](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/dax-metrics-dimensions-dax.html) |
| Amazon EC2 | Yes | CPU utilization, network in/out | [Link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch.html) |
| Amazon EC2 Elastic Graphics | Yes | GPU utilization | [Link](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/elastic-graphics-cloudwatch.html) |
| Amazon EC2 Spot Fleet | Yes | Fleet requests | [Link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-fleet-cloudwatch-metrics.html) |
| Amazon EC2 Auto Scaling | Yes | Group desired capacity | [Link](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-instance-monitoring.html) |
| AWS Elastic Beanstalk | Yes | Environment health | [Link](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/health-enhanced-cloudwatch.html) |
| Amazon Elastic Block Store | Yes | Volume read/write ops | [Link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using_cloudwatch_ebs.html) |
| Amazon Elastic Container Registry | Yes | Repository pulls | [Link](https://docs.aws.amazon.com/AmazonECR/latest/userguide/ecr-repository-metrics.html) |
| Amazon Elastic Container Service | Yes | Task CPU/memory | [Link](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cloudwatch-metrics.html) |
| Amazon ECS through CloudWatch Container Insights | Yes | Cluster utilization | [Link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-metrics-ECS.html) |
| Amazon ECS Cluster auto scaling | Yes | Capacity providers | [Link](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-auto-scaling.html#asg-capacity-providers-managed-scaling) |
| AWS Elastic Disaster Recovery | Yes | Replication status | [Link](https://docs.aws.amazon.com/drs/latest/userguide/monitoring-event-bridge-metrics.html) |
| Amazon Elastic File System | Yes | Permitted throughput | [Link](https://docs.aws.amazon.com/efs/latest/ug/monitoring-cloudwatch.html) |
| Amazon Elastic Inference | Yes | Inference utilizations | [Link](https://docs.aws.amazon.com/elastic-inference/latest/developerguide/ei-cloudwatch-metrics.html) |
| Amazon EKS | Yes | Cluster node counts | [Link](https://docs.aws.amazon.com/eks/latest/userguide/cloudwatch.html#cloudwatch-basic-metrics) |
| Amazon EKS through CloudWatch Container Insights | Yes | Pod CPU/memory | [Link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-metrics-EKS.html) |
| Elastic Load Balancing (ALB) | Yes | Request count, latency | [Link](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-cloudwatch-metrics.html) |
| Elastic Load Balancing (NLB) | Yes | Active connections | [Link](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-cloudwatch-metrics.html) |
| Elastic Load Balancing (GLB) | Yes | Processed bytes | [Link](https://docs.aws.amazon.com/elasticloadbalancing/latest/gateway/cloudwatch-metrics.html) |
| Elastic Load Balancing (Classic) | Yes | Healthy hosts | [Link](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-cloudwatch-metrics.html) |
| Amazon Elastic Transcoder | Yes | Job progress | [Link](https://docs.aws.amazon.com/elastictranscoder/latest/developerguide/monitoring-cloudwatch.html) |
| Amazon ElastiCache (Memcached) | Yes | Cache hits/misses | [Link](https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/CacheMetrics.html) |
| Amazon ElastiCache (Redis) | Yes | Commands processed | [Link](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheMetrics.html) |
| Amazon OpenSearch Service | Yes | Cluster status | [Link](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-cloudwatchmetrics.html) |
| Amazon EMR | Yes | Cluster steps | [Link](https://docs.aws.amazon.com/emr/latest/ManagementGuide/UsingEMR_ViewingMetrics.html) |
| Amazon EMR Serverless | Yes | Application runs | [Link](https://docs.aws.amazon.com/emr/latest/ManagementGuide/app-job-metrics.html) |
| AWS Elemental MediaConnect | Yes | Flow health | [Link](https://docs.aws.amazon.com/mediaconnect/latest/ug/monitor-with-cloudwatch.html) |
| AWS Elemental MediaConvert | Yes | Job encodes | [Link](https://docs.aws.amazon.com/mediaconvert/latest/ug/MediaConvert-metrics.html) |
| AWS Elemental MediaLive | Yes | Channel inputs | [Link](https://docs.aws.amazon.com/medialive/latest/ug/monitoring-eml-metrics.html) |
| AWS Elemental MediaPackage | Yes | Channel requests | [Link](https://docs.aws.amazon.com/mediapackage/latest/ug/monitoring-cloudwatch.html#metrics) |
| AWS Elemental MediaStore | Yes | Container requests | [Link](https://docs.aws.amazon.com/mediastore/latest/ug/monitor-with-cloudwatch-metrics.html) |
| AWS Elemental MediaTailor | Yes | Playback errors | [Link](https://docs.aws.amazon.com/mediatailor/latest/ug/monitoring-cloudwatch.html) |
| AWS End User Messaging SMS | Yes | Message deliveries | [Link](https://docs.aws.amazon.com/sms-voice/latest/userguide/monitoring-cloudwatch.html) |
| AWS End User Messaging Social | Yes | Channel sends | [Link](https://docs.aws.amazon.com/social-messaging/latest/userguide/monitoring-cloudwatch.html) |
| Amazon EventBridge | Yes | Rule invocations | [Link](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-monitoring.html) |
| Amazon FinSpace | Yes | Cluster loads | [Link](https://docs.aws.amazon.com/finspace/latest/userguide/kdb-cluster-logging-monitoring.html) |
| Amazon Forecast | Yes | Dataset imports | [Link](https://docs.aws.amazon.com/forecast/latest/dg/cloudwatch-metrics.html) |
| Amazon Fraud Detector | Yes | Detector evaluations | [Link](https://docs.aws.amazon.com/frauddetector/latest/ug/monitoring-cloudwatch.html#YourService-metrics) |
| Amazon FSx for Lustre | Yes | Data read bytes | [Link](https://docs.aws.amazon.com/fsx/latest/LustreGuide/monitoring_overview.html) |
| Amazon FSx for OpenZFS | Yes | Dataset throughput | [Link](https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/monitoring-cloudwatch.html) |
| Amazon FSx for Windows File Server | Yes | Free space | [Link](https://docs.aws.amazon.com/fsx/latest/WindowsGuide/monitoring_overview.html) |
| Amazon FSx for NetApp ONTAP | Yes | Volume IOPS | [Link](https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/monitoring-cloudwatch.html) |
| Amazon GameLift Servers | Yes | Fleet utilization | [Link](https://docs.aws.amazon.com/gamelift/latest/developerguide/monitoring-cloudwatch.html) |
| AWS Global Accelerator | Yes | Client processed bytes | [Link](https://docs.aws.amazon.com/global-accelerator/latest/dg/cloudwatch-monitoring.html) |
| AWS Glue | Yes | Job runs | [Link](https://docs.aws.amazon.com/glue/latest/dg/monitoring-awsglue-with-cloudwatch-metrics.html) |
| AWS Ground Station | Yes | Contact durations | [Link](https://docs.aws.amazon.com/ground-station/latest/ug/metrics.html) |
| AWS HealthLake | Yes | Store queries | [Link](https://docs.aws.amazon.com/healthlake/latest/devguide/monitoring-cloudwatch.html) |
| Amazon Inspector | Yes | Assessment runs | [Link](https://docs.aws.amazon.com/inspector/latest/userguide/using-cloudwatch.html) |
| Amazon Interactive Video Service | Yes | Stream viewers | [Link](https://docs.aws.amazon.com/ivs/latest/userguide/ivs-metrics.html) |
| Amazon Interactive Video Service Chat | Yes | Message sends | [Link](https://docs.aws.amazon.com/ivs/latest/userguide/ivs-metrics.html) |
| AWS IoT | Yes | Message deliveries | [Link](https://docs.aws.amazon.com/iot/latest/developerguide/metrics_dimensions.html) |

*(Table truncated for brevity; full list includes 100+ services like AWS IoT Core, Amazon Kinesis, AWS Lambda, Amazon MSK, Amazon Neptune, Amazon QLDB, Amazon Redshift, Amazon S3, Amazon SageMaker, AWS Secrets Manager, Amazon SNS, Amazon SQS, AWS Step Functions, Amazon Timestream, and more. All basic metrics are free.)*

#### Detailed Basic Free Metrics for Popular Services
Here are examples of free basic metrics generated by AWS for monitoring key services. These are automatically emitted at 5-minute intervals.

**Amazon EC2 (Namespace: AWS/EC2)**
- CPUUtilization
- DiskReadOps
- DiskWriteOps
- DiskReadBytes
- DiskWriteBytes
- NetworkIn
- NetworkOut
- NetworkPacketsIn
- NetworkPacketsOut
- StatusCheckFailed
- StatusCheckFailed_Instance
- StatusCheckFailed_System

**Amazon S3 (Namespace: AWS/S3)**
- **Daily Storage**: BucketSizeBytes, NumberOfObjects
- **Requests**: AllRequests, GetRequests, PutRequests, DeleteRequests, HeadRequests, PostRequests, ListRequests, BytesDownloaded, BytesUploaded, 4xxErrors, 5xxErrors, FirstByteLatency, TotalRequestLatency
- **Replication**: ReplicationLatency, BytesPendingReplication, OperationsPendingReplication, OperationsFailedReplication

**Amazon RDS (Namespace: AWS/RDS)**
- BinLogDiskUsage
- BurstBalance
- CPUUtilization
- CPUCreditUsage
- CPUCreditBalance
- DatabaseConnections
- DiskQueueDepth
- FreeableMemory
- FreeStorageSpace
- NetworkReceiveThroughput
- NetworkTransmitThroughput
- ReadIOPS
- ReadLatency
- ReadThroughput
- ReplicaLag
- SwapUsage
- WriteIOPS
- WriteLatency
- WriteThroughput

**AWS Lambda (Namespace: AWS/Lambda)**
Basic free metrics include:
- Invocations (number of times a function is invoked)
- Duration (execution time in ms)
- Errors (function errors)
- Throttles (throttled invocations)
- DeadLetterErrors (errors sending to DLQ)
- IteratorAge (for stream sources, age of last record)

**Amazon DynamoDB (Namespace: AWS/DynamoDB)**
- ConsumedReadCapacityUnits
- ConsumedWriteCapacityUnits
- ReadThrottleEvents
- WriteThrottleEvents
- ReturnedItemCount
- SuccessfulRequestLatency
- SystemErrors
- UserErrors
- ThrottledRequests
- TransactionConflict

**Elastic Load Balancing - Application Load Balancer (Namespace: AWS/ApplicationELB)**
- ActiveConnectionCount
- NewConnectionCount
- ProcessedBytes
- RequestCount
- HTTPCode_ELB_3XX_Count
- HTTPCode_ELB_4XX_Count
- HTTPCode_ELB_5XX_Count
- HealthyHostCount
- UnHealthyHostCount
- TargetResponseTime
  
</details>

### [AWS CloudWatch Metrics Pricing Overview](https://cloudchipr.com/blog/cloudwatch-pricing#cloudwatch-metrics-pricing)
#### 1. Default (Standard) CloudWatch Metrics Pricing
Default metrics are automatically emitted by AWS services (e.g., EC2, RDS, Lambda) at standard resolution. These are free under basic monitoring—no per-metric charge or API hits for ingestion.

<details>
    <summary>Click to view Key details of Default Metrics</summary>

Default metrics from AWS services are not free at 1-minute intervals across all AWS services. Most AWS services provide **basic monitoring** by default, which includes a standard set of metrics published to Amazon CloudWatch at 5-minute intervals with no additional charge (beyond standard CloudWatch storage and API costs, which have generous free tiers). Detailed monitoring, which offers 1-minute granularity for those same default metrics, must be explicitly enabled on supported services and incurs charges.

### Key Details on Default Metrics and Intervals
- **Basic Monitoring (Default for Most Services)**: Automatically enabled when you start using the service. Metrics are free, but limited to 5-minute periods. Examples include CPU utilization, network I/O, and disk metrics for Amazon EC2; request counts and latency for Amazon API Gateway; and storage metrics for Amazon S3 (reported daily by default, not 1-minute).
- **Detailed Monitoring (1-Minute Intervals)**: Available only on select services (e.g., EC2, RDS, Auto Scaling groups, API Gateway). It's not enabled by default—you must activate it via the AWS Management Console, CLI, or API. Once enabled, these higher-resolution metrics are treated like custom metrics and are charged at $0.30 per metric per month for the first 10,000 metrics (with volume discounts beyond that). The first 10 detailed/custom metrics are free each month.
- **Service Variations**: No AWS services provide 1-minute default metrics for free across the board. For instance:
  - Amazon S3: Default storage metrics are free but daily; 1-minute request metrics require opt-in and are charged as custom metrics.
  - Amazon EC2: Default is 5-minute basic (free); enabling 1-minute detailed monitoring charges based on the number of metrics per instance (e.g., ~26 metrics per instance at $0.30 each).
  - Other services like Lambda or DynamoDB follow similar patterns: basic (often 1- or 5-minute) is free, but enhanced granularity may require paid features.

| Monitoring Type | Default Interval | Free? | Charge for 1-Min? | Example Services |
|-----------------|------------------|-------|-------------------|------------------|
| Basic | 5 minutes (or coarser, e.g., daily for S3 storage) | Yes | N/A (can't change to 1-min without detailed) | EC2, RDS, S3, API Gateway, Lambda |
| Detailed | 1 minute | No (must enable) | Yes ($0.30/metric/month after free tier) | EC2, RDS, Auto Scaling, API Gateway |

### Impact of Changing Metrics Resolution
Yes, if you change the resolution of default metrics to 1 minute (e.g., by enabling detailed monitoring), it will incur charges—even though these are still "default" metrics from the service. This is because CloudWatch treats detailed monitoring data points as billable custom/detailed metrics. You won't be charged for the basic 5-minute data, but the 1-minute version adds to your metric count. API requests to retrieve or view these metrics are also charged after the free tier (1 million requests/month).

For the most current pricing (as of October 2025), check the [CloudWatch pricing page](https://aws.amazon.com/cloudwatch/pricing/), as rates can vary by region. If you're using a specific service, review its documentation for exact metric details.
  
</details>

- **Free**: All basic default metrics from AWS services.
- **Limitations**: If you enable **detailed monitoring** (1-minute resolution on top of basic), it counts as custom metrics and is charged after the 10-free limit.
- **Cost structure** (for any charged custom/detailed metrics, including dynamic ones like disk space from EC2):
  | Tier | Metrics per Month | Price per Metric/Month |
  |------|-------------------|------------------------|
  | First | 10,000 | $0.30 |
  | Next (10,001–250,000) | 240,000 | $0.10 |
  | Next (250,001+) | Unlimited | $0.05 |

  - **Example for your scenario**: With thousands of metrics from AWS services + custom (assume 5,000 total custom metrics/month):
    - First 10 free.
    - Next 4,990 at $0.30 = ~$1,497/month.
    - Yearly estimate: ~$17,964 (assumes consistent usage; actual prorated).
  - **Resolution impact**: Standard is default (no extra cost). High-resolution metrics (e.g., for low-latency apps) use the same tiers but generate more data points, increasing API/stream costs if you query/export them.
  - **API requests for metrics** (e.g., retrieving data via GetMetricData API):
    - $0.01 per 1,000 requests after 1M free/month.
    - **Example**: 10 million requests/month = ~$90/month after free tier (9M charged × $0.01/1K). Yearly: ~$1,080.
    - Dynamic metrics (e.g., disk space) are ingested free if basic, but queries hit API limits.

#### 2. Metric Filters from Logs
Metric filters extract custom metrics from CloudWatch Logs (e.g., parsing error counts from app logs). This incurs **logs ingestion/archival costs** + **custom metric charges** (as the extracted value becomes a stored metric).

- **Free tier**: First 5 GB logs ingested/archived per month.
- **Cost structure**:
  | Component | Pricing (after free tier) |
  |-----------|---------------------------|
  | Logs Ingestion | $0.50/GB (first 10 TB/month); tiers down to $0.05/GB for 100+ TB. Vended logs (e.g., from VPC Flow Logs) have separate delivery fees (~$0.50/GB initially). |
  | Logs Archival | $0.03/GB/month. |
  | Extracted Metric | Same as custom metrics above ($0.30+ per metric/month). |

  - **Example**: 30 GB logs/month with 5 extracted metrics:
    - Ingestion: 25 GB charged × $0.50 = $12.50.
    - Archival: ~6 GB compressed × $0.03 = $0.18.
    - Metrics: 5 × $0.30 = $1.50.
    - Total: ~$14.18/month. Yearly: ~$170.
  - **High usage note**: For dynamic logs (e.g., high-volume disk metrics), costs scale with GB ingested. Filters don't add resolution fees but increase custom metric count.
  - **Contributor Insights** (advanced log-based metrics): First rule free; $0.50/rule/month + $0.02 per million matched events after 1M free.

#### 3. [Modified/Created Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_billing.html) (e.g., Combining Two Metrics with Sum, Avg)
You can create **derived metrics** using math expressions (e.g., SUM(CPU) + AVG(Memory)) via the console, APIs, or alarms. These aren't stored as new metrics unless you publish them via PutMetricData—otherwise, they're computed on-the-fly.

- **Cost if computed on-the-fly** (e.g., in alarms or queries):
  - No storage cost; charged via **alarm** ($0.10 per underlying metric/alarm/month) or **Metrics Insights query** ($0.01 per 1,000 metrics analyzed).
  - **Example**: Alarm combining 3 metrics (sum/avg): $0.10 × 3 = $0.30/month per alarm. Yearly: ~$3.60.
- **Cost if stored as custom metric** (e.g., publish the result):
  - Treated as a new custom metric: $0.30+ per metric/month (same tiers as above).
  - Plus API request for publishing: Included in the 1M free PutMetricData calls.
- **Limitations**: Each combined metric can add to your total count (e.g., anomaly detection adds 3 metrics per alarm: actual + upper/lower bounds).
- **Resolution**: Follows the input metrics; high-res inputs make the output high-res.

#### 4. [CloudWatch Agent Sending Metrics to CloudWatch](https://www.vantage.sh/blog/cloudwatch-metrics-pricing-explained-in-plain-english)
The CloudWatch agent (installed on EC2/on-premises) collects and sends custom metrics/logs (e.g., disk space, custom app metrics) via PutMetricData API. No separate agent fee—costs are for the metrics/logs sent.

- **Cost structure**:
  - **Metrics sent**: Custom metric rates ($0.30+ per metric/month after 10 free).
  - **API calls**: PutMetricData included in 1M free requests/month; $0.01/1K after.
  - **If sending logs too**: Logs ingestion ($0.50/GB after 5 GB free).
- **Example**: Agent on 10 EC2 instances sending 20 custom metrics each (200 total/month) + disk space (dynamic, 1-min resolution):
  - Metrics: 200 × $0.30 = $60/month.
  - API: Assume 1 call/minute per instance (14,400/month total) = free (under 1M).
  - Yearly estimate: $720 (metrics only).
- **High usage**: For thousands of metrics, volume tiers kick in (e.g., 50,000 metrics = ~$5,150/month after tiers). Agent doesn't affect resolution pricing directly.

#### Tips for Your Setup (Thousands of Metrics)
- **Total cost drivers**: Custom/dynamic metrics dominate (e.g., $0.30 each initially). Monitor via AWS Cost Explorer to tag and optimize.
- **Reducing costs**: Use basic monitoring where possible, delete unused metrics, or stream to S3 for cheaper storage ($0.003/1K updates via Metric Streams).
- **Free plan structure**: Monthly reset—ideal for low-volume testing. No yearly free equivalent.
- For exact yearly projection with your AWS services/custom setup, input into the AWS Pricing Calculator.

