#resource "tls_private_key" "ed25519-test1" {
# algorithm = "ED25519"
#}

#resource "aws_key_pair" "generated_key" {
# key_name = var.key_name
# public_key = tls_private_key.ed25519-test1.public_key_openssh
# depends_on = [
#  tls_private_key.ed25519-test1
# ]
#}

#resource "local_file" "key" {
# content = tls_private_key.ed25519-test1.private_key_pem
# filename = "test1.pem"
# file_permission ="0400"
# depends_on = [
#  tls_private_key.ed25519-test1
# ]
#}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
  #public_key = file("~/.ssh/id_ed25519.pub")
  public_key = var.ec2_ssh_key
}