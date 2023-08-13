##################
# Security group #
##################

resource "aws_security_group" "test1_sg" {
  name        = "allow_for_test1"
  description = "Allow SSH/HTTP/HTTPS inbound traffic"
  vpc_id      = aws_vpc.test1_vpc.id

  tags = {
    Name = "allow_basic_test1"
  }
}

resource "aws_security_group_rule" "test1_ingress_http" {
  type              = "ingress"
  description       = "HTTP from VPC"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allow_ip
  security_group_id = aws_security_group.test1_sg.id
}

resource "aws_security_group_rule" "test1_ingress_https" {
  type              = "ingress"
  description       = "HTTPS from VPC"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allow_ip
  security_group_id = aws_security_group.test1_sg.id
}

# resource "aws_security_group_rule" "test1_ingress_ssh" {
  # type              = "ingress"
  # description       = "SSH from VPC"
  # from_port         = 22
  # to_port           = 22
  # protocol          = "tcp"
  # cidr_blocks       = var.allow_ip
  # security_group_id = aws_security_group.test1_sg.id
# }

resource "aws_security_group_rule" "test1_ingress_ssh_all" {
  type              = "ingress"
  description       = "SSH from VPC for all"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allow_ip
  security_group_id = aws_security_group.test1_sg.id
}

resource "aws_security_group_rule" "test1_egress_all" {
  type              = "egress"
  description       = "allow all output egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # mean all
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test1_sg.id
}