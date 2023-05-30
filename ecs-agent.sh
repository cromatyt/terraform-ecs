#!/bin/bash

# Intall docker

sudo yum remove docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine \
                podman \
                runc

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

sudo yum install docker-ce-${DOCKER_VERSION} docker-ce-cli-${DOCKER_VERSION} containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl start docker

# List of avalable ecs agent packages
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-install.html#ecs-agent-install-nonamazonlinux

sudo rpm -ivh https://s3.eu-west-1.amazonaws.com/amazon-ecs-agent-eu-west-1/amazon-ecs-init-latest.x86_64.rpm
sudo systemctl start ecs

echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config
