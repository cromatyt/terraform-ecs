######################
# Auto scaling group #
######################

#locals {
#  ecs_agent = templatefile("${path.module}/ecs-agent.sh", { ecs_cluster_name = var.ecs_cluster_name, DOCKER_VERSION = var.docker_version })
#}

resource "aws_launch_template" "ecs_launch_config" {
  name                    = "my-launch-template"
  image_id                = var.ami
  #vpc_security_group_ids  = [aws_security_group.test1_sg.id]
  depends_on              = [aws_internet_gateway.test1_ig]
  user_data               = base64encode(templatefile("${path.module}/ecs-agent.sh", { ecs_cluster_name = var.ecs_cluster_name, DOCKER_VERSION = var.docker_version }))
  instance_type           = var.ec2_instance_type
  key_name                = var.key_name # for ssh key config

  network_interfaces {
    associate_public_ip_address = true
    security_groups  = [aws_security_group.test1_sg.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_iam_agent.name
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "instance-${var.project_name}-${var.environment}"
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  count                     = length(var.public_subnet_cidrs)
  name_prefix               = "myasg-"
  vpc_zone_identifier       = [aws_subnet.public_subnets[count.index].id]

  launch_template {
    id      = aws_launch_template.ecs_launch_config.id
    version = aws_launch_template.ecs_launch_config.latest_version
  }

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}
