resource "aws_cloudwatch_metric_alarm" "alarm_test1" {
  alarm_name                = "alarm-test1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  # actions_enabled = true
  insufficient_data_actions = []
  ok_actions = []
  # alarm_actions = ["${aws_autoscaling_policy.ecs-asg_increase.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "alarm_test1_MEM" {
  alarm_name                = "alarm-test1-MEM"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  # actions_enabled = true
  insufficient_data_actions = []
  ok_actions = []
  # alarm_actions = ["${aws_autoscaling_policy.ecs-asg_increase.arn}"]
}
