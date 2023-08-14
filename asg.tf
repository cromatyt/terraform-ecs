######################
# Auto scaling group #
######################

#locals {
#  ecs_agent = templatefile("${path.module}/ecs-agent.sh", { ecs_cluster_name = var.ecs_cluster_name, DOCKER_VERSION = var.docker_version })
#}

resource "aws_launch_template" "ecs_launch_config" {
  # name_prefix             = "${var.environment}-"
  name                    = "${var.environment}-my-launch-template"
  image_id                = var.ami
  depends_on              = [aws_internet_gateway.test1_ig]
  # user_data               = filebase64("user_data.sh")
  user_data               = base64encode(templatefile("${path.module}/ecs-agent.sh", { ecs_cluster_name = var.ecs_cluster_name, DOCKER_VERSION = var.docker_version }))
  instance_type           = var.ec2_instance_type
  key_name                = var.key_name # for ssh key config

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.test1_sg_lb.id, aws_security_group.test1_sg_ssh.id]
    # subnet_id                   = aws_subnet.private_subnets
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_iam_agent.name
  }

  monitoring {
    enabled = true
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
  # count                     = length(var.public_subnet_cidrs)
  name_prefix               = "myasg-"
  vpc_zone_identifier       = aws_subnet.public_subnets.*.id

  launch_template {
    id      = aws_launch_template.ecs_launch_config.id
    # version = aws_launch_template.ecs_launch_config.latest_version
    version = "$Latest"
  }

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 120
  health_check_type         = "EC2"

  protect_from_scale_in = true

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  depends_on = [ aws_launch_template.ecs_launch_config ]
}
