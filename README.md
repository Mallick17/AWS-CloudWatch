---

# **Monitoring Memory Usage on AWS EC2 using CloudWatch Agent**

---

### **Step 1: Create an IAM Role for CloudWatch Agent**

**Navigate to IAM**

- In the AWS Management Console, search for **IAM** and select it.

**Create IAM Role**

- Click **Roles** > **Create Role**.
- Trusted entity type: **AWS Service**.
- Use case: **EC2**.
- Click **Next: Permissions**.
- Search and select policy: `CloudWatchAgentServerPolicy`.
- Click **Next: Tags** (optional).
- Click **Next: Review**.
- Role name: `EC2CloudWatchAgentRole`.
- Click **Create role**.

**Reason:**

This IAM role grants EC2 instances the permissions required to run and send custom metrics (like memory usage) to Amazon CloudWatch using the CloudWatch Agent.

---

### **Step 2: Attach IAM Role to EC2 Instance**

**Navigate to EC2**

- In the AWS Console, go to **EC2**, then click on **Instances**.

**Attach Role**

- Select the instance you want to monitor.
- Click **Actions** > **Security** > **Modify IAM Role**.
- Select the IAM role: `EC2CloudWatchAgentRole`.
- Click **Update IAM Role**.

**Reason:**

Attaching the IAM role allows the CloudWatch Agent running on the EC2 instance to authenticate and publish memory metrics to CloudWatch.

---

### **Step 3: Install CloudWatch Agent on EC2 Instance**

**Connect to EC2 via SSH**

- Use SSH to connect to your EC2 instance.

**Install the Agent**

_For Amazon Linux 2:_
```bash
sudo yum install amazon-cloudwatch-agent -y
```

_For Ubuntu:_
```bash
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
```

**Reason:**

The CloudWatch Agent is necessary for collecting and pushing system-level metrics (like memory usage) to CloudWatch, which aren't available by default.

---

### **Step 4: Create CloudWatch Agent Configuration File**

**Create Config File**

```bash
sudo nano /opt/aws/amazon-cloudwatch-agent/bin/config.json
```

**Paste the following JSON:**
```json
{
  "metrics": {
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    },
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    }
  }
}
```

**Reason:**

This configuration tells the agent to collect the memory usage percentage every 60 seconds and tag the metric with the instance ID for easier filtering in CloudWatch.

---

### **Step 5: Start the CloudWatch Agent**

**Start Agent with Config File**

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s
```

**Reason:**

This command fetches the config file, initializes the agent, and starts collecting memory metrics.

---

### **Step 6: Verify Metrics in CloudWatch**

**Navigate to CloudWatch**

- Go to **CloudWatch** in the AWS Console.
- Click on **Metrics** in the left sidebar.
- Look under the **CWAgent** namespace.
- Select `mem_used_percent` with dimension `InstanceId`.

**Reason:**

Verifying in CloudWatch ensures that your agent is working correctly and memory metrics are being reported for monitoring and alerting.

---

Refference: [Wojciech Lepczyński - DevOps Cloud Architect - How to monitor memory usage on AWS EC2 ??](https://lepczynski.it/en/aws_en/how-to-monitor-memory-usage-on-aws-ec2/)
