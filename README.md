## [AWS CloudWatch Metrics Pricing Overview](https://cloudchipr.com/blog/cloudwatch-pricing#cloudwatch-metrics-pricing)
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

## CloudWatch Charges for Metrics with No Data Points
No, If you've created custom metrics in Amazon CloudWatch but no data points (output) are published to them, you are **not charged** for those metrics. CloudWatch charges for custom and detailed metrics are based on the number of active metrics, prorated hourly—but a metric is only considered active (and billable) during an hour when at least one data point is published to it via the PutMetricData API, CloudWatch Agent, or service emissions. If no data is sent in a given hour, no charge applies for that period.

This applies to:
- **Custom metrics**: Defined by a unique combination of namespace, metric name, and dimensions (e.g., a metric like "CPUUtilization" under a custom namespace). If inactive, they don't accrue costs.
- **Detailed monitoring metrics**: Treated like custom metrics; charges only when data is emitted at 1-minute intervals (which requires enabling it and having activity).

Basic monitoring metrics from AWS services (e.g., standard EC2 CPU metrics at 5-minute intervals) are always free, regardless of data points.

#### Key Details on Metric Charges and Inactivity
- **Proration and Billing**: $0.30 per metric per month for the first 10,000 (with tiered discounts beyond that), but only for hours with data publication. The first 10 custom/detailed metrics are free monthly.
- **Expiration for Inactive Metrics**: Metrics automatically expire after 15 months if no data points are published in the last 2 weeks. Older data points roll off based on retention periods (e.g., 15 days for 1-minute data).
- **Common Pitfalls**: If a CloudWatch Agent or script is running and configured to collect metrics, it may continue publishing data points (even zeros or defaults), triggering hourly charges. Stop/uninstall the agent to avoid this.
- **Alarms Note**: This doesn't apply to alarms, which are charged $0.10/month each regardless of activity or metric data.

| Scenario | Charged? | Reason | Example |
|----------|----------|--------|---------|
| Custom metric created, no data published | No | No hourly data points = no proration | PutMetricData called once to define, but never with values |
| Metric receives data sporadically (e.g., 1 hour/week) | Partial | Prorated for active hours only | ~$0.0125/hour of activity ($0.30/24 hours/month) |
| Detailed monitoring enabled, no activity | Yes (if enabled) | Service may emit baseline data points | EC2 detailed: Charges for ~7 metrics/instance if 1-min data flows |
| Basic AWS metrics (free tier) | No | Always free, even with data | S3 request counts at 5-min intervals |

For the latest pricing (as of October 2025), check the [CloudWatch pricing page](https://aws.amazon.com/cloudwatch/pricing/) or use the AWS Cost Explorer to audit your metrics. If you're seeing unexpected charges, review active custom namespaces in the CloudWatch console under Metrics > All metrics.
