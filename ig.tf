####################
# Internet gateway #
####################

resource "aws_internet_gateway" "test1_ig" { 
  vpc_id = aws_vpc.test1_vpc.id

  tags = {
    Name = "test1_ig"
  } 
}