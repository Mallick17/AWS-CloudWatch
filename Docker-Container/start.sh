#!/bin/bash

# Start NGINX
echo "Starting Nginx..."
nginx

# Start CloudWatch Agent
echo "Starting CloudWatch Agent..."
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -s

# Keep the container running
tail -f /var/log/nginx/access.log
