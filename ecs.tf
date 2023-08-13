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

resource "aws_ecs_capacity_provider" "ecs_cp_test1" {
  name = var.ecs_capacity_provider

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      # maximum_scaling_step_size = 100
      # minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_cp_test1" {
  cluster_name       = aws_ecs_cluster.ecs_cluster_test1.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_cp_test1.name]
}

resource "aws_ecs_task_definition" "task_definition_test1" {
  family                    = "td_test1"
  # requires_compatibilities  = ["EC2"]

  container_definitions = jsonencode([
    {
      name      = "container1"
      image     = "traefik/whoami:v1.9"
      cpu       = 50
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          # hostPort      = 80
        }
      ]
      "healthcheck": {
        "command": ["CMD-SHELL", "curl 127.0.0.1:80"]
        # "interval": ,
        # "timeout": ,
        # "retries": ,
        # "startPeriod":
      }
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
  desired_count   = 1
  #launch_type     = "EC2"

  alarms {
    enable   = true
    rollback = true
    alarm_names = [
      aws_cloudwatch_metric_alarm.alarm_test1_CPU.alarm_name,
      aws_cloudwatch_metric_alarm.alarm_test1_MEM.alarm_name,
    ]
  }
}
