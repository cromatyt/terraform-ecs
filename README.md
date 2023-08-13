# Terraform aws

:warning: In this example I use ubuntu 22:04 ami which is [not officially support by ec2](https://github.com/aws/amazon-ecs-agent/issues/3227) !

That why I add AppArmor section in ecs-agent.sh file :warning:

## Description

This project will deploy an ECS environment on AWS with EC2 instances (no Fargate).

## Required

1. Configure SSH

    Generate ed25519 pem key local (here on linux device): `ssh-keygen -t ed25519 -m PEM -f FILE_NAME.pem -C 'SOME COMMENT'` and copy the publique key into the ssh folder project

2. Set AWS access in Github action secrets:

| Name | Descrtption | Type |
| --- | --- | --- |
|AWS_ACCESS_KEY_ID | Your AWS ACCESS KEY | string |
|AWS_SECRET_ACCESS_KEY| Your AWS SECRET KEY | string |
|AWS_DEFAULT_REGION | Your AWS region | string |
| MY_IP | list of your allowed IP (add network mask for each) | list |

3. Set the IP list that you want to allow to access to your security group, Github action secrets name `MY_IP`.

## List of verify sections

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
- [ ] Loadbalancer # need remove ecs portMappings
- [ ] Cloudwatch
- [ ] Output
