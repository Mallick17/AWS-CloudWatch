FROM amazonlinux:2

# Install nginx and cloudwatch agent
RUN yum update -y && \
    yum install -y amazon-linux-extras && \
    amazon-linux-extras enable nginx1 && \
    yum clean metadata && \
    yum install -y nginx curl unzip procps && \
    curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm && \
    yum install -y amazon-cloudwatch-agent.rpm && \
    rm -f amazon-cloudwatch-agent.rpm && \
    yum clean all

# Copy your configs and startup script
COPY nginx.conf /etc/nginx/nginx.conf
COPY cloudwatch-config.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
COPY start.sh /start.sh

RUN chmod +x /start.sh

# Create log directory
RUN mkdir -p /var/log/nginx && touch /var/log/nginx/access.log

EXPOSE 80

CMD ["/start.sh"]
