#!/bin/bash

## Intall docker

sudo apt-get update
# sudo apt upgrade -y
sudo apt-get install -y ca-certificates curl gnupg

## Modify apparmor for ecs-agent with ubuntu 22.04
sudo touch /etc/apparmor.d/docker-default
sudo sh -c "cat >> /etc/apparmor.d/docker-default" <<-EOF
#include <tunables/global>

profile docker-default flags=(attach_disconnected,mediate_deleted) {
  #include <abstractions/base>

  network,
  capability,
  file,
  umount,

  # Host (privileged) processes may send signals to container processes.
  signal (receive) peer=unconfined,
  # dockerd may send signals to container processes (for "docker kill").
  signal (receive) peer=unconfined,
  # Container processes may send signals amongst themselves.
  signal (send,receive) peer=docker-default,

  deny @{PROC}/* w,   # deny write for all files directly in /proc (not in a subdir)
  # deny write to files not in /proc/<number>/** or /proc/sys/**
  deny @{PROC}/{[^1-9],[^1-9][^0-9],[^1-9s][^0-9y][^0-9s],[^1-9][^0-9][^0-9][^0-9/]*}/** w,
  deny @{PROC}/sys/[^k]** w,  # deny /proc/sys except /proc/sys/k* (effectively /proc/sys/kernel)
  deny @{PROC}/sys/kernel/{?,??,[^s][^h][^m]**} w,  # deny everything except shm* in /proc/sys/kernel/
  deny @{PROC}/sysrq-trigger rwklx,
  deny @{PROC}/kcore rwklx,

  deny mount,

  deny /sys/[^f]*/** wklx,
  deny /sys/f[^s]*/** wklx,
  deny /sys/fs/[^c]*/** wklx,
  deny /sys/fs/c[^g]*/** wklx,
  deny /sys/fs/cg[^r]*/** wklx,
  deny /sys/firmware/** rwklx,
  deny /sys/kernel/security/** rwklx,

  # suppress ptrace denials when using 'docker ps' or using 'ps' inside a container
  ptrace (trace,read,tracedby,readby) peer=docker-default,

  # suppress ptrace denials when agent and process-agent are accessing /proc
  ptrace (read),
  # The ECS Agent needs access to dbus in order to launch tasks
  dbus (send, receive, bind),
}
EOF

sudo apparmor_parser -r /etc/apparmor.d/docker-default
sudo systemctl reload apparmor

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

sudo apt-get install -y docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io docker-buildx-plugin docker-compose-plugin

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