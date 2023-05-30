#######
# VPC #
#######

resource "aws_vpc" "test1_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-${var.project_name}-${var.env}"
    Environment = var.environment
  }
}