resource "aws_route_table" "test1_route" {
  vpc_id = aws_vpc.test1_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test1_ig.id
  }

  tags = {
    Name = "test1_route"
  }
}

resource "aws_route_table_association" "test1_route_asso_pub" {
  count           = length(var.public_subnet_cidrs)
  subnet_id       = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id  = aws_route_table.test1_route.id
}