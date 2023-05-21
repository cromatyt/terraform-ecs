output "ec2_test" {
  description = "ID of the EC2 instance"
  value = aws_instance.test1.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.test1.public_ip
}