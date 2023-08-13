###############
# Route table #
###############

# Here you create public route only because the private one is automatically create
resource "aws_route_table" "public_test1_route" {
  vpc_id = aws_vpc.test1_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test1_ig.id
  }

   tags = {
    Name        = "public-route-${var.project_name}-${var.environment}}"
    Environment = var.environment
 }
}

resource "aws_route_table_association" "test1_route_asso_pub" {
  count           = length(var.public_subnet_cidrs)
  subnet_id       = aws_subnet.public_subnets[count.index].id
  # subnet_id       = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id  = aws_route_table.public_test1_route.id
}

# resource "aws_main_route_table_association" "public_main" {
#   vpc_id         = aws_vpc.test1_vpc.id
#   route_table_id = aws_route_table.public_test1_route.id
# }