resource "aws_instance" "test1" {
  ami           = "ami-017d70213b2dbe508" #redhat 9 eu-west-1
  instance_type = "t2.micro"

  tags = {
    Name = var.ec2_instance_name
  }
}