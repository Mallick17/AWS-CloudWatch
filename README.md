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
