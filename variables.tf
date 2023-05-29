#variable "AWS_REGION" {
#  type = string
#}

variable "allow_ip" {
  type = list(string)
  sensitive = true  
}

variable "ami" {
  type = string
  default = "ami-013d87f7217614e10" # Red Hat 9
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

variable "az" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

#variable "some_password" {
#  type = string
#  sensitive = true
#}