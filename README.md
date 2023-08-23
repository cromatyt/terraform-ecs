# Terraform aws (no Fargate)

:warning: In this example I use ubuntu 22:04 ami which is [not officially support by ecs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-anywhere.html) !

That why I add AppArmor section in ecs-agent.sh file ([ref](https://github.com/aws/amazon-ecs-agent/issues/3227)) :warning:

## Description

This project will deploy an ECS environment on AWS with EC2 instances (ASG / no Fargate).

## Required

1. Configure SSH

    Generate ed25519 pem key local (here on linux device): `ssh-keygen -t ed25519 -m PEM -f FILE_NAME.pem -C 'SOME COMMENT'` and copy the publique key into the ssh folder project.
   Delete existing public key in the SSH folder and if you set a specific file name, modify `ec2_ssh_key_path` terraform variable default value with it.

3. Set AWS access in Github action secrets:

| Name | Descrtption | Type |
| --- | --- | --- |
|AWS_ACCESS_KEY_ID | Your AWS ACCESS KEY | string |
|AWS_SECRET_ACCESS_KEY| Your AWS SECRET KEY | string |
|AWS_DEFAULT_REGION | Your AWS region | string |
| MY_IP | IP list that you want to allow (add network mask for each) | list |

3. Configure/create an AWS S3 then edit version.tf => backend "s3" section
   If you use this project for the first time, you will need to create the S3 manually

5. You can custom ecs-agent.sh script if you want to add some linux packages/configurations

## Work in progress

- [X] VPC
- [X] Subnet
- [X] Internet Gateway (ig)
- [X] Route Table
- [X] Security group (sg)
- [X] Autoscaling group (asg)
- [X] IAM
- [X] SSH
- [X] ECS
- [ ] ECR
- [X] Loadbalancer (lb) # need remove ecs portMappings
- [ ] Cloudwatch
- [ ] Output

## Troubleshoots

By default ECS do not delete task definition, it only deactivate them. You will need to use aws-cli or console to clean them
