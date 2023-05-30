##########
# Subnet #
##########

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.test1_vpc.id
 cidr_block        = var.public_subnet_cidrs[count.index]
 availability_zone = var.az[count.index]
 
 tags = {
    Name        = "sb-${var.project_name}-public_subnets${count.index + 1}-${var.env}"
    Environment = var.environment
 }
}
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.test1_vpc.id
 cidr_block        = var.private_subnet_cidrs[count.index]
 availability_zone = var.az[count.index]
 
 tags = {
    Name        = "sb-${var.project_name}-private_subnets${count.index + 1}-${var.env}"
    Environment = var.environment
 }
}
