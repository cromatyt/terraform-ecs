######################
# Auto scaling group #
######################

#resource "aws_autoscaling_policy" "test1_asg" {
#  name = "test1_asg"
#  scaling_adjustment = 1
#  adjustment_type = "ChangeInCapacity"
#  cooldown = 300
#  autoscaling_group_name = "${aws_autoscaling_group.web.name}"
#}
#
#resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
#  alarm_name = "web_cpu_alarm_up"
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods = "2"
#  metric_name = "CPUUtilization"
#  namespace = "AWS/EC2"
#  period = "120"
#  statistic = "Average"
#  threshold = "70"
#dimensions = {
#    AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
#  }
#alarm_description = "This metric monitor EC2 instance CPU utilization"
#  alarm_actions = [ "${aws_autoscaling_policy.web_policy_up.arn}" ]
#}
#
#resource "aws_autoscaling_policy" "web_policy_down" {
#  name = "web_policy_down"
#  scaling_adjustment = -1
#  adjustment_type = "ChangeInCapacity"
#  cooldown = 300
#  autoscaling_group_name = "${aws_autoscaling_group.web.name}"
#}
#
#resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
#  alarm_name = "web_cpu_alarm_down"
#  comparison_operator = "LessThanOrEqualToThreshold"
#  evaluation_periods = "2"
#  metric_name = "CPUUtilization"
#  namespace = "AWS/EC2"
#  period = "120"
#  statistic = "Average"
#  threshold = "30"
#dimensions = {
#    AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
#  }
#alarm_description = "This metric monitor EC2 instance CPU utilization"
#  alarm_actions = [ "${aws_autoscaling_policy.web_policy_down.arn}" ]
#}

resource "aws_launch_template" "ecs_launch_config" {
  name                    = "my-launch-template"
  image_id                = var.ami
  vpc_security_group_ids  = [aws_security_group.test1_sg.id]
  user_data               = "#!/bin/bash\necho ECS_CLUSTER=my-cluster >> /etc/ecs/ecs.config"
  instance_type           = var.ec2_instance_type
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  count                     = length(var.public_subnet_cidrs)
  name_prefix               = "myasg-"
  vpc_zone_identifier       = [aws_subnet.public_subnets[count.index].id]

  desired_capacity          = 3
  min_size                  = 3
  max_size                  = 6
  health_check_grace_period = 300
  health_check_type         = "EC2"
}