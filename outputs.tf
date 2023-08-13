#########
# Ouput #
#########

data "aws_instances" "my_intances_test1" {
  instance_tags {
    name = "instance-${var.project_name}-${var.environment}"
  }
}

# output "ec2_test" {
  # description = "ID of the EC2 instance"
  # value = aws_instance.test1[*].id
  # sensitive = false
# }

output "instance_public_ip" {
 description = "Public IP address of the EC2 instance"
#  value       = aws_instance.test1[*].public_ip
 value       = "${data.aws_instances.my_intances_test1.public_ips}"
 sensitive   = false
}

# output "security_group_test1_sg" {
  # value = aws_security_group.test1_sg.id
# }
