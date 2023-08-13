########
# Ecs #
#######

resource "aws_ecs_cluster" "ecs_cluster_test1" {
  name  = var.ecs_cluster_name

  lifecycle {
    create_before_destroy = true
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "ECSCluster_${var.ecs_cluster_name}_${var.environment}"
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
          hostPort      = 80
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
  name                               = "service_test1"
  iam_role                           = aws_iam_role.ecs_iam_role.arn #need lb
  cluster                            = aws_ecs_cluster.ecs_cluster_test1.id
  task_definition                    = aws_ecs_task_definition.task_definition_test1.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = var.ecs_task_deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.ecs_task_deployment_maximum_percent
  #launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_alb_target_group.XXXX.arn
    container_name   = "service_test1"
    container_port   = 80
  }

  ## Spread tasks evenly accross all Availability Zones for High Availability
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ## Make use of all available space on the Container Instances
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }

  ## Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [desired_count]
  }

  alarms {
    enable   = true
    rollback = true
    alarm_names = [
      aws_cloudwatch_metric_alarm.alarm_test1_CPU.alarm_name,
      aws_cloudwatch_metric_alarm.alarm_test1_MEM.alarm_name,
    ]
  }
}
