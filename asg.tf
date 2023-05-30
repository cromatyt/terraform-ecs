######################
# Auto scaling group #
######################

locals {
  ecs_agent = templatefile("${path.module}/ecs-agent.sh", { ecs_cluster_name = var.ecs_cluster_name })
}

resource "aws_launch_template" "ecs_launch_config" {
  name                    = "my-launch-template"
  image_id                = var.ami
  vpc_security_group_ids  = [aws_security_group.test1_sg.id]
  user_data               = base64encode(local.ecs_agent)
  instance_type           = var.ec2_instance_type
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
}

resource "aws_autoscaling_group_tag" "ecs_asg_tag" {
  count = length(var.private_subnet_cidrs)

  tags = {
    Name = "${var.ecs_cluster_name}-${count.index}"
  }
}