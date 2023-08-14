#################
# Load balancer #
#################

resource "aws_lb" "lb_test1" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test1_sg_lb.id, aws_security_group.test1_sg_ssh.id]
  subnets            = aws_subnet.public_subnets.*.id

  # enable_deletion_protection = true

  # access_logs {
    # bucket  = aws_s3_bucket.lb_logs.id
    # prefix  = var.lb_name
    # enabled = true
  # }

  tags = {
    name        = "LB-${var.lb_name}"
    Environment = var.environment
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "lb_listener_http_test1" {
  load_balancer_arn = aws_lb.lb_test1.arn
  port              = "80"
  protocol          = "HTTP"

  # default_action {
  #   type = "fixed-response"

  #   fixed_response {
  #     content_type = "text/plain"
  #     message_body = "Access denied"
  #     status_code  = "403"
  #   }
  # }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_test1.arn
  }

  depends_on = [aws_lb.lb_test1]
}

resource "aws_lb_target_group" "lb_target_group_test1" {
  name                 = var.lb_target_group
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = aws_vpc.test1_vpc.id
  deregistration_delay = 120 # default 300

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    interval            = "120"
    matcher             = "200,301,302"
    path                = "/"
    # port                = "traffic-port"
    # protocol            = "HTTP"
    timeout             = "60"
  }
  
  depends_on = [aws_lb.lb_test1]
}
