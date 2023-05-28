#variable "AWS_REGION" {
#  type = string
#}

variable "ami" {
  type = string
  default = "ami-04b82270e2c61ea45" #redhat 9 eu-west-1
}

variable "key_name" {
  type = string
  default = "test1_key"
}

variable "ec2_ssh_key" {
  type = string
  sensitive = true
}

variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
}

variable "ec2_instance_number" {
  type = number
  default = 1
}

variable "ec2_instance_name" {
  type = string
  default = "DefaultInstanceName"
}

#variable "some_password" {
#  type = string
#  sensitive = true
#}