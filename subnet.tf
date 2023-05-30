##########
# Subnet #
##########

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.test1_vpc.id
 cidr_block        = var.public_subnet_cidrs[count.index]
 availability_zone = var.az[count.index]
 
 tags = {
    Name        = "sb-${aws_subnet.public_subnets[count.index].arn}"
    Environment = var.environment
 }
}
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.test1_vpc.id
 cidr_block        = var.private_subnet_cidrs[count.index]
 availability_zone = var.az[count.index]
 
 tags = {
    Name        = "sb-${aws_subnet.private_subnets[count.index].arn}"
    Environment = var.environment
 }
}
