#################
# Load balancer #
#################

resource "aws_lb" "lb_test1" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test1_sg.id]
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