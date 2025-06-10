# CloudWatch Agent Configuration Files

## 🧩 1. `append_dimensions`

### ➤ Purpose:

**Adds custom dimensions** to every metric emitted by the CloudWatch Agent.

### ✅ Effect:

* These dimensions are **attached to each metric data point**.
* They allow you to filter and identify metrics in the CloudWatch console or in queries.

### 🧪 Example:

```json
"append_dimensions": {
  "InstanceId": "${aws:InstanceId}",
  "InstanceType": "${aws:InstanceType}",
  "AutoScalingGroupName": "${aws:AutoScalingGroupName}"
}
```

📌 With this, metrics like `disk_used` will now show up in CloudWatch with:

```
InstanceId=i-0abcd12345, InstanceType=t3.micro, AutoScalingGroupName=my-asg
```

---

## 📊 2. `aggregation_dimensions`

### ➤ Purpose:

**Controls how CloudWatch aggregates** metrics in the console when viewed via the CloudWatch Agent’s custom namespace.

### ✅ Effect:

* This affects **how metrics are grouped** in CloudWatch (e.g., graphs, dashboards).
* It does **not affect what dimensions are attached** to the metric data (that’s `append_dimensions`).

### 🧪 Example:

```json
"aggregation_dimensions": [
  ["InstanceId"],
  ["AutoScalingGroupName"],
  ["InstanceType"],
  ["InstanceId", "InstanceType"],
  []
]
```

📌 With this:

* CloudWatch will automatically provide roll-ups like:

  * Avg CPU per Auto Scaling group
  * Total disk usage across all t3.micro instances
  * Metrics across all instances (with `[]`)

---

## 🔁 Summary Table

| Feature                             | `append_dimensions`                   | `aggregation_dimensions`                             |
| ----------------------------------- | ------------------------------------- | ---------------------------------------------------- |
| Purpose                             | Add dimensions to each metric         | Control CloudWatch's roll-up and grouping of metrics |
| Affects metric storage              | ✅ Yes                                 | ❌ No                                                 |
| Affects viewing/grouping in console | ❌ No                                  | ✅ Yes                                                |
| Example use case                    | Identify which instance sent a metric | View total disk used per Auto Scaling group          |

---

### 🧠 Best Practice:

Use both:

* `append_dimensions` to label every metric with useful metadata.
* `aggregation_dimensions` to make those dimensions available for filtering and roll-up in CloudWatch graphs and dashboards.
