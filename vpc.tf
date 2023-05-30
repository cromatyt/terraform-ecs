#######
# VPC #
#######

resource "aws_vpc" "test1_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-${aws_vpc.test1_vpc.arn}"
    Environment = var.environment
  }
}