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

# CloudWatch Cost
- **Metrics Cost:** You pay monthly for the number of unique metrics monitored, here 2 metrics at $0.30 each.
- **High Resolution Metrics:** Pricing is same per metric regardless of data frequency, but you pay more if you send metrics every second (high resolution). Your current 60 sec interval is standard resolution, so no high resolution charge applies unless you reduce interval.
- **API Costs:** API cost is for sending/fetching metric data. You send 60 API calls per hour which sums about 43,200 calls per month. Priced at $0.01 per 1,000 requests, resulting in about $0.44/month.

## AWS provides a free tier every month (reset monthly):
- _Basic monitoring metrics_ from AWS services (e.g., EC2 CPU utilization, S3 request counts): Completely free, no limits on volume.
- _Custom/detailed monitoring metrics:_ First 10 metrics per month free.
- _API requests (e.g., GetMetricData calls):_ First 1 million free per month (excludes some like GetMetricData, which are always charged).
- _Alarms:_ Up to 10 standard alarms on basic metrics free.
> This covers many small workloads, but with thousands of metrics, you'll likely exceed it and pay tiered rates.

##
