##########
# Subnet #
##########

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.test1_vpc.id
 cidr_block        = var.public_subnet_cidrs[count.index]
 availability_zone = var.az[count.index]
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.test1_vpc.id
 cidr_block        = var.private_subnet_cidrs[count.index]
 availability_zone = var.az[count.index]
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}
