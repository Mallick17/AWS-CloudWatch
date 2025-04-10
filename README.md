# Amazon CloudWatch
- Amazon CloudWAtch is a monitoring and observation service that is built for DevOps Engineers, developers, security engineers and IT managers.
- CloudWatch provides you with data and actionable insights to monitor your applications, respond to system-wide performance changes, and optimize resource utilization. You get a unified view of operational health.

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

---
   
</details>
