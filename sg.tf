##################
# Security group #
##################

resource "aws_security_group" "test1_sg_lb" {
  name        = "allow_for_test1_lb_dynamic"
  description = "Allow Dynamic port + HTTP/HTTPS inbound traffic"
  vpc_id      = aws_vpc.test1_vpc.id

  tags = {
    Name = "allow_basic_test1_lb_dynamic"
  }
}

resource "aws_security_group" "test1_sg_ssh" {
  name        = "allow_for_test1_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.test1_vpc.id

  tags = {
    Name = "allow_basic_test1_ssh"
  }
}

# Rule to dynamic ports ecs
resource "aws_security_group_rule" "test1_ingress_lb_dynamic_ecs_port" {
  type              = "ingress"
  description       = "Allow ingress traffic from LB dynamic port"
  from_port         = 32768
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test1_sg_lb.id
}

resource "aws_security_group_rule" "test1_ingress_lb_http" {
  type              = "ingress"
  description       = "Allow HTTP from LB"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test1_sg_lb.id
}

resource "aws_security_group_rule" "test1_ingress_lb_https" {
  type              = "ingress"
  description       = "Allow HTTPS from LB"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test1_sg_lb.id
}

# Rule to allow SSH from internet
resource "aws_security_group_rule" "test1_ingress_ssh_private_ip" {
  type              = "ingress"
  description       = "SSH from VPC for custom IP list"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allow_ip
  security_group_id = aws_security_group.test1_sg_ssh.id
}

# Rule to allow all egress traffic
resource "aws_security_group_rule" "test1_egress_all" {
  type              = "egress"
  description       = "allow all output egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # mean all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test1_sg_ssh.id
}