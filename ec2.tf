########
# Ec2 #
#######

#resource "aws_instance" "test1" {
#  ami                         = var.ami
#  count                       = length(var.private_subnet_cidrs)
#  instance_type               = var.ec2_instance_type
#  key_name                    = var.key_name # for ssh key config
#  vpc_security_group_ids      = [aws_security_group.test1_sg.id]
#  depends_on                  = [aws_internet_gateway.test1_ig]
#  subnet_id                   = aws_subnet.public_subnets[count.index].id
#  associate_public_ip_address = true
#
#  tags = {
#    Name = "${var.ec2_instance_name}-${count.index}"
#  }
#
#  credit_specification {
#    cpu_credits = "standard"
#  }
#
#}
