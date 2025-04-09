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

#### Step 3: Add Name and Description
Provide a clear identifier and context for the alarm.

- **Components:**
  - **Alarm Name:** A unique name (e.g., `Mallow_Alarm`) to identify the alarm in the CloudWatch console.
  - **Alarm Description:** An optional description (e.g., “This alarm monitors CPU utilization for the ROR-App instance”) to provide context. Supports Markdown formatting for console display (plain text in notifications).

- **Key Points:**
  - Use descriptive names to avoid confusion, especially with multiple alarms.
  - Keep the description concise but informative (up to 1024 characters).

#### Step 4: Preview and Create
Review and finalize the alarm configuration.

- **Components:**
  - **Preview:** Displays a summary of the metric, conditions, actions, and name/description.
  - **Create Alarm:** Submits the configuration to CloudWatch.

- **Key Points:**
  - Double-check all settings before creating.
  - After creation, the alarm appears in the CloudWatch Alarms list and begins monitoring.

---
## Alarm Received in the as per the Configuration
![image](https://github.com/user-attachments/assets/39ec98bc-4bca-4891-99fb-40f5d28eeaff)
