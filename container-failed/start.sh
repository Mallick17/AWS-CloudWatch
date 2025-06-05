#!/bin/bash

echo "Starting CloudWatch agent..."
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent \
  -config file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -envconfig file:/opt/aws/amazon-cloudwatch-agent/etc/env-config.json \
  -pidfile /tmp/cw-agent.pid &

echo "Starting Nginx..."
nginx -g "daemon off;"
