#######
# Ecs #
#######

resource "aws_ecs_cluster" "ecs_cluster_test1" {
  name  = var.ecs_cluster_name

  lifecycle {
    create_before_destroy = false
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

  skip_destroy               = true
  
  ## Available soon ?
  # delete_all_iterations_on_dispose = true
  # delete_on_deregister = true

  container_definitions = jsonencode([
    {
      name      = "container1"
      image     = "nginx:1.25.1-bookworm"
      cpu       = 50
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0 # need LB !
          protocol      = "tcp"
        }
      ]
      "healthcheck": {
        "command": ["CMD-SHELL", "curl -f 127.0.0.1"]
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
  iam_role                           = aws_iam_role.ecs_iam_role.arn # need lb
  cluster                            = aws_ecs_cluster.ecs_cluster_test1.id
  task_definition                    = aws_ecs_task_definition.task_definition_test1.arn
  desired_count                      = 2
  # deployment_minimum_healthy_percent = 
  # deployment_maximum_percent         = 
  #launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group_test1.arn
    container_name   = "container1"
    container_port   = 80
  }

  ## Spread tasks evenly accross all Availability Zones for High Availability
  # ordered_placement_strategy {
  #   type  = "spread"
  #   field = "attribute:ecs.availability-zone"
  # }

  ## Make use of all available space on the Container Instances
  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }

  ## Optional: Allow external changes without Terraform plan difference
  # lifecycle {
  #   ignore_changes = [desired_count]
  # }

  alarms {
    enable   = true
    rollback = true
    alarm_names = [
      aws_cloudwatch_metric_alarm.alarm_test1_CPU.alarm_name,
      aws_cloudwatch_metric_alarm.alarm_test1_MEM.alarm_name,
    ]
  }

  # Prevent against "aws_ecs_service.ecs_service: Still destroying..." TimeOut
  provisioner "local-exec" {
    when = destroy
    command = "chmod +x ${path.module}/scripts/stop-tasks.sh"
    environment = {
      CLUSTER = self.name
    }
  }

  # To prevent ECS service to get stuck in the DRAINING state (need aws_iam_role_policy)
  depends_on = [ aws_iam_role.ecs_iam_role, aws_autoscaling_group.ecs_asg]

}
