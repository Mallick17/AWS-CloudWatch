FROM amazonlinux:2

# Install Nginx and CloudWatch Agent
RUN amazon-linux-extras install nginx1 -y && \
    yum install -y curl unzip procps amazon-cloudwatch-agent && \
    yum clean all

# Copy CloudWatch agent config to correct path
COPY amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
COPY env-config.json /opt/aws/amazon-cloudwatch-agent/etc/env-config.json

# Copy the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
