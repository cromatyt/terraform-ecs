########
# Ecs #
#######

resource "aws_ecs_cluster" "ecs_cluster_test1" {
  name  = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task_definition_test1" {
  family                    = "td_test1"
  # requires_compatibilities  = ["EC2"]
  # network_mode              =

  container_definitions = jsonencode([
    {
      name      = "container1"
      image     = "traefik/whoami:v1.9"
      cpu       = 512
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  tags = {
      Name = "td_test1"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "service_test1"
  cluster         = aws_ecs_cluster.ecs_cluster_test1.id
  task_definition = aws_ecs_task_definition.task_definition_test1.arn
  desired_count   = 2
  #launch_type     = "EC2"

  alarms {
    enable   = true
    rollback = true
    alarm_names = [
      aws_cloudwatch_metric_alarm.alarm_test1.alarm_name
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_test1" {
  alarm_name                = "alarm-test1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}