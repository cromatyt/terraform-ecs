#!/bin/bash

# Intall docker

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

## Add docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

## Add docker to source list
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## Install docker packages
sudo apt-get -y update

sudo apt-get install -y docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker ubuntu # here ubuntu is the ami default user

sudo systemctl enable docker
sudo systemctl start docker

## Install Amazon ECS container agent
## help https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-install.html
curl -O https://s3.eu-west-1.amazonaws.com/amazon-ecs-agent-eu-west-1/amazon-ecs-init-latest.amd64.deb
sudo dpkg -i amazon-ecs-init-latest.amd64.deb

sudo sh -c "echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config"

sudo systemctl enable ecs
sudo systemctl start ecs