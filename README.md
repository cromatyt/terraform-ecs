# Terraform aws

## Description

This project will deploy an ec2 environment on AWS.
Currently, it deploys an ec2 instance on each subnet of your AWS region.
Target => deploy ecs cluster on ec2 instances.

To do associate ec2 instance to ecs cluster.

## Required

1. Configure SSH

    1. Generate ed25519 pem key local (here on linux device): `ssh-keygen -t ed25519 -m PEM -f FILE_NAME.pem -C 'SOME COMMENT'`

    2. Copy your public key to your Github actions with `EC2_SSH_PUB_KEY` secret name.

2. Set AWS access in Github action secrets:

| Name | Descrtption |
| --- | --- |
|AWS_ACCESS_KEY_ID | Your AWS ACCESS KEY |
|AWS_SECRET_ACCESS_KEY| Your AWS SECRET KEY |
|AWS_DEFAULT_REGION | Your AWS region |

3. Set the IP list that you want to allow to access to yout security group, Github action secrets name `MY_IP`.

## Check

- [X] VPC
- [X] Subnet
- [X] Internet Gateway (ig)
- [X] Route Table
- [x] Security group (sg)
- [ ] Autoscaling group (asg)
- [x] IAM
- [X] SSH
- [ ] ECS
- [ ] ECR
- [ ] Loadbalancer
