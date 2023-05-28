resource "aws_instance" "test1" {
  ami = var.ami
  #count = var.ec2_instance_number
  instance_type = var.ec2_instance_type
  key_name = var.key_name

  tags = {
    Name = var.ec2_instance_name
  }

  credit_specification {
    cpu_credits = "standard"
  }

}
