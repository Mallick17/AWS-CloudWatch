# Build stage: Install CloudWatch Agent on Debian base image
FROM debian:latest as build

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Download and install the CloudWatch agent for Debian
RUN curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb && \
    dpkg -i -E amazon-cloudwatch-agent.deb && \
    rm -rf /tmp/* && \
    # Clean up unnecessary CloudWatch agent binaries
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/config-downloader

# Final stage: Minimal image (scratch)
FROM debian:latest

# Install Nginx and necessary utilities
RUN apt-get update && \
    apt-get install -y nginx ca-certificates curl unzip procps && \
    rm -rf /var/lib/apt/lists/*

# Copy CloudWatch Agent binaries and configuration from build stage
COPY --from=build /opt/aws/amazon-cloudwatch-agent /opt/aws/amazon-cloudwatch-agent
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Copy CloudWatch Agent configuration file into the container
COPY config.json /opt/aws/amazon-cloudwatch-agent/bin/config.json

# Expose the necessary port for Nginx
EXPOSE 80
