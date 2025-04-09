# CloudWatch Alarm
Amazon CloudWatch is a monitoring and observability service that collects and tracks metrics, logs, and events from AWS resources and applications. A CloudWatch Alarm watches a single metric over a specified time period and performs actions (e.g., sending notifications) when the metric breaches a defined threshold. By integrating with SNS, you can send these notifications to an email address after setting up a subscription.

### Step-by-Step Process

#### Step 1: Specify Metric and Conditions
This is the foundation of the alarm, where you define what to monitor and the conditions that trigger it.

- **Components:**
  - **Metric Selection:**
    - Choose a metric to monitor (e.g., `CPUUtilization` for an EC2 instance).
    - Metrics are data points (e.g., CPU usage percentage) collected by CloudWatch.
    - In the example, the metric is `CPUUtilization` from the `AWS/EC2` namespace for a specific instance (e.g., `i-09d7e99ae60e1809`).
  - **Graph:**
    - A visual representation of the metric over time helps you understand its behavior.
    - The graph shows the current value (blue line) and the threshold (red line). The alarm triggers if the blue line crosses below the red line for the specified datapoints (e.g., 1 datapoint within 30 seconds).
  - **Conditions:**
    - **Threshold Type:** Select `Static` to use a fixed value as the threshold (e.g., 10% CPU utilization) or `Anomaly Detection` for dynamic thresholds based on historical patterns.
    - **Condition:** Define when to trigger the alarm (e.g., `Lower` than 10%). Options include `Greater`, `Greater/Equal`, `Lower`, or `Lower/Equal` compared to the threshold.
    - **Threshold Value:** Set the value (e.g., 10 for 10% CPU utilization).
    - **Period and Datapoints:** Specify the evaluation period (e.g., 30 seconds) and the number of datapoints to evaluate (e.g., 1 datapoint).

- **Key Points:**
  - Ensure the metric is relevant to the resource you’re monitoring.
  - Adjust the period and datapoints based on how frequently you want the alarm to check (shorter periods may incur additional costs for high-resolution alarms).
  - Preview the graph to validate the threshold setting.

<details>
  <summary>Refference Images</summary>

## Step 1
![Specify metric and conditions - Step 1](https://github.com/user-attachments/assets/d7d78fe9-84f4-43d2-bed6-a2e3f2211718)

---

![Widget Type](https://github.com/user-attachments/assets/1bdad67b-a1ed-4201-b010-67996f3a85d8)

---

![Multi Source Query](https://github.com/user-attachments/assets/f6c484c7-0529-420a-afc4-d8fc667c0660)

---

![Metrices](https://github.com/user-attachments/assets/64224fa9-28fb-4b60-acee-11b810ce71be)

---

![Source](https://github.com/user-attachments/assets/1f129cba-4391-4fd3-9b06-9a79e0d99d10)

---

![Graphed Metrices](https://github.com/user-attachments/assets/4c4ad730-38d1-4613-b01a-5154bae1a35c)
  
</details>


#### Step 2: Configure Actions
This step defines what happens when the alarm state changes (e.g., from `OK` to `In Alarm`).

- **Components:**
  - **Notification:**
    - **Alarm State Trigger:** Choose when to send the notification (e.g., `In Alarm` when the metric is outside the threshold).
    - **SNS Topic:** Select or create an SNS topic to deliver the notification.
      - If creating a new topic, provide a name (e.g., `Mallow_CloudWatch_Alarms_Topic`).
      - SNS topics act as a communication channel to send messages to subscribers.
    - **Subscription:** Add an email endpoint (e.g., `gyanaranjanjammik44@gmail.com`) to the SNS topic.
      - After subscribing, AWS sends a confirmation email. You must confirm the subscription to receive alerts.
  - **Other Actions (Optional):**
    - **Lambda Action:** Trigger a Lambda function for automated responses.
    - **Auto Scaling Action:** Adjust scaling policies (e.g., add/remove instances).
    - **EC2 Action:** Perform EC2-specific actions (e.g., stop/start instances).
    - **Systems Manager Action:** Create incidents or OpsItems in Systems Manager.

- **Key Points:**
  - Ensure the SNS topic is created and subscribers are confirmed before testing the alarm.
  - Multiple actions can be configured for a single alarm.
  - Test the notification by changing the alarm state manually if needed.

<details>
  <summary>Refference Images</summary>

## Step 2
![Configure Actions - Step 2](https://github.com/user-attachments/assets/7ea12b60-2f69-419c-8d2b-5420dbecaac9)

---

![SNS Topic and Subscription](https://github.com/user-attachments/assets/0ec6f104-3cda-4730-8fa5-9782fc197026)

---

![Subscritpion Confirmed](https://github.com/user-attachments/assets/d72cf0ea-d6c3-4982-b672-1278705bab9e)

---

</details>  

#### Step 3: Add Name and Description
Provide a clear identifier and context for the alarm.

- **Components:**
  - **Alarm Name:** A unique name (e.g., `Mallow_Alarm`) to identify the alarm in the CloudWatch console.
  - **Alarm Description:** An optional description (e.g., “This alarm monitors CPU utilization for the ROR-App instance”) to provide context. Supports Markdown formatting for console display (plain text in notifications).

- **Key Points:**
  - Use descriptive names to avoid confusion, especially with multiple alarms.
  - Keep the description concise but informative (up to 1024 characters).


<details>
  <summary>Refference Images</summary>

![Add Name and Description - Step 3](https://github.com/user-attachments/assets/3fd9629e-208b-4c2b-9137-01f6b0ae60c8)

</details>  

#### Step 4: Preview and Create
Review and finalize the alarm configuration.

- **Components:**
  - **Preview:** Displays a summary of the metric, conditions, actions, and name/description.
  - **Create Alarm:** Submits the configuration to CloudWatch.

- **Key Points:**
  - Double-check all settings before creating.
  - After creation, the alarm appears in the CloudWatch Alarms list and begins monitoring.

<details>
  <summary>Refference Images</summary>

![Preview and Create - Step 4](https://github.com/user-attachments/assets/c99ad1aa-e4fe-4349-a6c7-aa34191e3e56)

</details>  

---

## CloudWatch
![CloudWatchAlarmCreated](https://github.com/user-attachments/assets/ed986e84-32a1-4811-a244-76ff80842249)


## Alarm Received in the as per the Configuration
![image](https://github.com/user-attachments/assets/39ec98bc-4bca-4891-99fb-40f5d28eeaff)

---
---

# CloudWatch Alarm with Additional Services
Amazon CloudWatch Alarms are highly versatile and can integrate with various AWS services to enhance monitoring, automation, and response capabilities. Beyond the basic setup with SNS for email notifications, you can incorporate additional AWS services to create a more robust and automated alerting system. Below, I’ll explain the process of creating a CloudWatch Alarm and expand on other services that can be used, providing detailed insights for beginners to professionals. I’ll also update the brief documentation to include these services.

<details>
  <summary>Step-by-Step Process for Creating a CloudWatch Alarm with Additional Services</summary>

### Step-by-Step Process for Creating a CloudWatch Alarm with Additional Services

#### Step 1: Specify Metric and Conditions
This step remains the same as outlined previously, where you select a metric (e.g., `CPUUtilization` for an EC2 instance) and define the conditions (e.g., `Lower` than 10% over a 30-second period). However, the choice of metric can involve data from other AWS services.

- **Additional Services for Metrics:**
  - **Amazon EC2:** Provides instance-level metrics like `CPUUtilization`, `NetworkIn`, and `NetworkOut`.
  - **Amazon RDS:** Monitors database metrics such as `CPUUtilization`, `DatabaseConnections`, and `FreeStorageSpace`.
  - **Amazon S3:** Tracks bucket metrics like `BucketSizeBytes` and `NumberOfObjects`.
  - **AWS Lambda:** Monitors invocation counts, duration, and errors via `Invocations`, `Duration`, and `Errors`.
  - **Amazon Elastic Load Balancer (ELB):** Tracks `HealthyHostCount`, `RequestCount`, and `Latency`.
  - **Amazon CloudFront:** Monitors `Requests`, `BytesDownloaded`, and `4xxErrorRate`.

- **Key Points:**
  - Select metrics from the appropriate namespace (e.g., `AWS/RDS`, `AWS/S3`) based on the service you’re monitoring.
  - Use the CloudWatch Metrics Explorer or custom metrics (via CloudWatch Agent or API) for more granular data.

#### Step 2: Configure Actions
This step defines the actions triggered when the alarm state changes. In addition to SNS, you can integrate other AWS services for automated responses.

- **Components and Additional Services:**
  - **Amazon Simple Notification Service (SNS):**
    - Sends notifications to email, SMS, or other endpoints (e.g., `gyanaranjanjammik44@gmail.com`).
    - Create a topic (e.g., `Mallow_CloudWatch_Alarms_Topic`) and subscribe the endpoint.
  - **AWS Lambda:**
    - Trigger a Lambda function to execute custom logic (e.g., scale resources, send custom alerts, or log to a database).
    - Example: A Lambda function could analyze the alarm data and send a detailed report to a Slack channel.
  - **Amazon EC2 Auto Scaling:**
    - Automatically adjust the number of EC2 instances based on alarm states.
    - Example: If `CPUUtilization` exceeds 80%, scale out by adding instances; if below 20%, scale in by removing instances.
  - **Amazon EC2 Actions:**
    - Perform instance-specific actions like stopping, terminating, or rebooting an EC2 instance.
    - Example: Stop an instance if `NetworkOut` drops to zero, indicating potential failure.
  - **AWS Systems Manager:**
    - Create an OpsItem or incident in Systems Manager OpsCenter for IT service management.
    - Example: Generate an OpsItem for `StatusCheckFailed` alarms to track and resolve issues.
  - **Amazon EventBridge (CloudWatch Events):**
    - Route alarm state changes to EventBridge rules, which can trigger other AWS services (e.g., Step Functions, Lambda, or SNS).
    - Example: Use EventBridge to start a Step Functions workflow for incident response.

- **Key Points:**
  - Combine multiple actions (e.g., SNS for notifications + Lambda for automation).
  - Ensure IAM roles have permissions for the integrated services (e.g., Lambda execution role, Auto Scaling policies).
  - Test action workflows to confirm they behave as expected.

#### Step 3: Add Name and Description
This step remains unchanged, where you name the alarm (e.g., `Mallow_Alarm`) and add a description. However, the description can reference the integrated services for clarity.

- **Example Description:**
  - “Monitors CPUUtilization for ROR-App instance. Triggers SNS notification to `Mallow_CloudWatch_Alarms_Topic`, scales via Auto Scaling, and creates an OpsItem in Systems Manager if breached.”

#### Step 4: Preview and Create
Review the configuration, including metrics, conditions, and actions involving multiple services, then create the alarm.

- **Key Points:**
  - Validate cross-service integrations in the preview.
  - Monitor the alarm state in the CloudWatch console after creation.

---
  
</details>

<details>
  <summary>Creating a CloudWatch Alarm with Multi-Service Integration in AWS</summary>

### Creating a CloudWatch Alarm with Multi-Service Integration in AWS

#### Objective
To set up a CloudWatch Alarm to monitor an EC2 instance’s `CPUUtilization` and integrate with SNS for email notifications, Auto Scaling for resource adjustment, and Systems Manager for incident management.

#### Prerequisites
- AWS account with permissions for CloudWatch, SNS, EC2, Auto Scaling, and Systems Manager.
- EC2 instance generating metrics.
- Confirmed SNS subscription and configured Auto Scaling group (if used).

#### Steps
1. **Specify Metric and Conditions**
   - Navigate to CloudWatch > Alarms > Create Alarm.
   - Select `CPUUtilization` from `AWS/EC2` for instance `i-09d7e99ae60e1809`.
   - Set a static threshold (e.g., `Lower` than 10%) with a 30-second period.
   - Explore metrics from RDS, S3, Lambda, or ELB if monitoring other services.

2. **Configure Actions**
   - **SNS:** Create a topic (`Mallow_CloudWatch_Alarms_Topic`) and subscribe an email (e.g., `gyanaranjanjammik44@gmail.com`).
   - **Auto Scaling:** Add a scaling policy to adjust instance count based on `CPUUtilization`.
   - **Systems Manager:** Create an OpsItem for incident tracking.
   - **Optional:** Integrate Lambda for custom logic, EventBridge for workflows, or SQS for queuing.

3. **Add Name and Description**
   - Name: `Mallow_Alarm`.
   - Description: “Monitors CPUUtilization for ROR-App instance. Triggers SNS, scales via Auto Scaling, and logs to Systems Manager.”

4. **Preview and Create**
   - Review all settings and create the alarm.

##### Additional Services
- **SQS:** Queue notifications for asynchronous processing.
- **SES:** Customize email content.
- **CloudTrail:** Log alarm changes for auditing.
- **Step Functions:** Orchestrate multi-step responses.
- **DynamoDB:** Store alarm history.
- **S3:** Archive alarm data.

#### Important Considerations
- **Permissions:** Ensure IAM roles allow access to all integrated services.
- **Costs:** High-resolution alarms and additional service usage (e.g., Lambda invocations) may incur charges.
- **Testing:** Simulate conditions to test notifications, scaling, and other actions.
- **Maintenance:** Regularly review thresholds and service integrations.

#### Troubleshooting
- **No Notifications:** Confirm SNS subscription and topic permissions.
- **Scaling Issues:** Check Auto Scaling group configuration and policies.
- **Service Errors:** Verify IAM roles and service quotas.

---
  
</details>

---


