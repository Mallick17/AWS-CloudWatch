## Overview
To run NGINX and the AWS CloudWatch agent in a single Docker container using amazonlinux:2, you need to install the necessary packages, configure Supervisord to manage both processes, and set up the CloudWatch agent to collect NGINX access logs and memory metrics. Below are the steps to create the Dockerfile, configuration files, and run the container.
- This solution allows you to run both NGINX and the AWS CloudWatch agent in one Docker container, sending NGINX access logs and memory usage metrics to CloudWatch. It uses Supervisord to manage multiple processes and ensures automatic creation of log groups and metrics in the CloudWatch console.
- To create a Docker container that runs NGINX, pushes its access logs to CloudWatch Logs, and sends memory usage metrics to CloudWatch Metrics using the CloudWatch agent—all within a single container—we need to modify the provided Dockerfile and config.json file. The goal is to ensure that the container automatically creates the log group and metrics in the AWS CloudWatch console and makes them visible. Below are the detailed steps to achieve this, including the necessary modifications, build process, and runtime instructions.

---

### Files

#### 1. Dockerfile
This updated Dockerfile enables the EPEL repository to install NGINX, optimizes disk usage by cleaning up after each `yum` command, and includes a workaround for the disk space issue.

```Dockerfile
FROM amazonlinux:2

# Enable EPEL repository and install necessary packages
RUN amazon-linux-extras install epel -y && \
    yum update -y && \
    yum install -y nginx python3-pip amazon-cloudwatch-agent && \
    yum clean all && \
    rm -rf /var/cache/yum

# Install Supervisord using pip3
RUN pip3 install supervisor

# Copy Supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf

# Copy CloudWatch agent configuration file
COPY config.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Ensure NGINX log directory permissions
RUN chmod -R 644 /var/log/nginx

# Expose NGINX port
EXPOSE 80

# Set the command to run Supervisord
CMD ["/usr/local/bin/supervisord", "-n"]
```

**Changes Made**:
- Added `amazon-linux-extras install epel -y` to enable the EPEL repository, which provides the `nginx` package.
- Added `yum clean all` after package installation to reduce disk usage by clearing the package cache.
- Kept the structure otherwise identical to ensure NGINX, Supervisord, and the CloudWatch agent are installed and configured correctly.

#### 2. Supervisord Configuration
This file remains unchanged, as it correctly configures Supervisord to manage NGINX and the CloudWatch agent.

```
[supervisord]
nodaemon=true

[program:nginx]
command=nginx -g 'daemon off;'
autostart=true
autorestart=true
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr

[program:cloudwatch-agent]
command=/opt/aws/amazon-cloudwatch-agent/bin/start-amazon-cloudwatch-agent
autostart=true
autorestart=true
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
```

#### 3. CloudWatch Agent Configuration
This file remains unchanged, as it correctly configures the CloudWatch agent to collect NGINX access logs and memory metrics in MB.

```json
{
   "metrics": {
      "metrics_collected": {
         "mem": {
            "measurement": [
               "mem_used"
            ],
            "metrics_collection_interval": 10,
            "unit": "Megabytes"
         }
      },
      "append_dimensions": {
        "ContainerName": "nginx-cloudwatch-agent-container"
      }
   },
   "logs": {
      "logs_collected": {
         "files": {
            "collect_list": [
               {
                  "file_path": "/var/log/nginx/access.log",
                  "log_group_name": "NginxLogGroup-mallick",
                  "log_stream_name": "mallick-nginxagent/access.log",
                  "timestamp_format": "[%d/%b/%Y:%H:%M:%S %z]"
               }
            ]
         }
      }
   }
}
```

---

### Instructions to Build and Run

#### Step 1: Prepare the Files
1. Create a directory (e.g., `super-nginx-watch`).
2. Save the above files as `Dockerfile`, `supervisord.conf`, and `config.json` in this directory by copying the content from each `<xaiArtifact>` block into the respective file.

#### Step 2: Address Disk Space Issue
The error indicates insufficient disk space (219 MB needed on `/`). To resolve this:
- **Check Available Space**: Run `df -h /` on the host to confirm available disk space. If it’s low, free up space by:
  - Removing unused Docker images: `docker image prune -a`.
  - Clearing Docker build cache: `docker builder prune`.
  - Freeing up disk space on the host: `rm -rf /tmp/*` or remove unnecessary files.
- **Increase Disk Space** (if on EC2):
  - Expand the root volume in the AWS EC2 console or attach additional storage.
  - For example, modify the EBS volume and run `sudo growpart /dev/nvme0n1 1` and `sudo resize2fs /dev/nvme0n1p1` (adjust device names as needed).
- **Verify**: After freeing space, confirm at least 500 MB is available on `/` to account for temporary files during the build.

#### Step 3: Set Up AWS Credentials
- **IAM Role (Preferred for EC2)**: If running on an EC2 instance, attach an IAM role with the following permissions (or use the AWS-managed `CloudWatchAgentServerPolicy`):
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "cloudwatch:PutMetricData"
        ],
        "Resource": "*"
      }
    ]
  }
  ```
- **Access Keys (For Non-EC2)**: Obtain an AWS access key ID and secret access key from an IAM user with the above permissions.

#### Step 4: Build the Docker Image
Navigate to the directory containing the files and run:
```bash
docker build -t nginx-cloudwatch-agent .
```

If the build fails again due to disk space, recheck available space or consider running on a host with more disk capacity (e.g., a larger EC2 instance).

#### Step 5: Run the Docker Container
- **On EC2 with IAM Role**:
  ```bash
  docker run -d -p 80:80 --name nginx-container nginx-cloudwatch-agent
  ```
- **Locally or Without IAM Role**:
  ```bash
  docker run -d \
    -e AWS_ACCESS_KEY_ID=your_access_key \
    -e AWS_SECRET_ACCESS_KEY=your_secret_key \
    -e AWS_REGION=your_region \
    -p 80:80 \
    --name nginx-container nginx-cloudwatch-agent
  ```
  Replace `your_access_key`, `your_secret_key`, and `your_region` with your AWS credentials and region (e.g., `us-east-1`).

#### Step 6: Verify in CloudWatch
1. **Generate Logs**:
   - Access NGINX to create log entries:
     ```bash
     curl http://localhost
     ```
     If running on a remote host, use the container’s IP or public IP.
2. **Check CloudWatch Logs**:
   - Open the AWS CloudWatch console.
   - Navigate to **Logs > Log Groups**.
   - Find `NginxLogGroup-mallick` and select the `mallick-nginxagent/access.log` stream.
   - Verify NGINX access logs with timestamps like `[DD/MMM/YYYY:HH:MM:SS +0000]`.
3. **Check CloudWatch Metrics**:
   - Go to **Metrics > All Metrics**.
   - Select the `CWAgent` namespace.
   - Filter by `ContainerName=nginx-cloudwatch-agent-container`.
   - Verify the `mem_used` metric shows memory usage in MB.

#### Step 7: Troubleshooting
- **NGINX Package Not Found**:
  - Ensure the `amazon-linux-extras install epel -y` command runs successfully. If it fails, verify internet connectivity in the build environment.
  - Alternatively, install NGINX manually by adding the EPEL repository explicitly:
    ```bash
    yum install -y epel-release
    ```
    Add this before `yum install nginx ...` in the Dockerfile if needed.
- **Disk Space Error**:
  - Recheck disk space with `df -h /`.
  - Run `docker system prune` to clear unused Docker objects.
  - If on EC2, increase the root volume size via the AWS console.
- **Logs Not Appearing**:
  - Verify NGINX logs: `docker exec -it nginx-container cat /var/log/nginx/access.log`.
  - Ensure the CloudWatch agent has permissions and `config.json` is correct.
- **Metrics Not Appearing**:
  - Confirm `mem_used` is supported in `config.json`.
  - Check container logs: `docker logs nginx-container`.
- **Container Exits**:
  - Inspect logs: `docker logs nginx-container`.
  - Verify Supervisord configuration and paths.

---

### Additional Notes
- **NGINX Configuration**: The default NGINX configuration in Amazon Linux 2 logs to `/var/log/nginx/access.log`, matching `config.json`. If custom logging is needed, create an `nginx.conf` and add `COPY nginx.conf /etc/nginx/nginx.conf` to the Dockerfile.
- **Disk Space Optimization**: The `yum clean all` command minimizes the image size. If disk issues persist, consider a multi-stage build to reduce temporary files, but this single-stage approach is simpler for a trial test.
- **Production Considerations**: Use IAM roles with ECS/EKS for production. For persistent logs, mount a volume with `-v /path/to/logs:/var/log/nginx`.
- **Log Group Creation**: The CloudWatch agent automatically creates the log group and stream if IAM permissions are correct.

This revised setup addresses the build errors by enabling the EPEL repository for NGINX and optimizing disk usage. The files are organized for easy copy-pasting, and the instructions ensure a successful build and deployment for your trial test.
