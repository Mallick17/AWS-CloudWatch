#!/bin/bash

# Run CloudWatch Agent with full command and debug output
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s

# Start NGINX in the foreground
nginx -g 'daemon off;'
