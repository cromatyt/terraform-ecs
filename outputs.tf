#########
# Ouput #
#########

data "aws_instances" "my_instances_test1" {
  filter {
    name  = "tag:Name"
    values = ["instance-${var.project_name}-${var.environment}"]
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
 value       = "${data.aws_instances.my_instances_test1.public_ips}"
 sensitive   = false
}

output "instance_name" {
  description = "Instance name"
  value       = "${data.aws_instances.my_instances_test1.id}"
}

output "lb_dns" {
  description = "Load Balancer"
  value       = "${aws_lb.lb_test1.dns_name}"
}
