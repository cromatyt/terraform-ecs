######################
# Auto scaling group #
######################

resource "aws_launch_template" "ecs_launch_config" {
  name                    = "my-launch-template"
  image_id                = var.ami
  vpc_security_group_ids  = [aws_security_group.test1_sg.id]
  #user_data               = "#!/bin/bash\necho ECS_CLUSTER=my-cluster >> /etc/ecs/ecs.config"
  instance_type           = var.ec2_instance_type
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  count                     = length(var.public_subnet_cidrs)
  name_prefix               = "myasg-"
  vpc_zone_identifier       = [aws_subnet.public_subnets[count.index].id]

  launch_template {
    id      = aws_launch_template.ecs_launch_config.id
    version = aws_launch_template.ecs_launch_config.latest_version
  }

  desired_capacity          = 3
  min_size                  = 3
  max_size                  = 6
  health_check_grace_period = 300
  health_check_type         = "EC2"
}