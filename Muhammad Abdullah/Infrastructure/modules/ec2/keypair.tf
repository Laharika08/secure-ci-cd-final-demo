resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "${var.project_info[0]}-${var.project_info[1]}-ec2-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "local-private-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "${path.root}/outputs/${var.project_info[0]}-${var.project_info[1]}-ec2-private-key.pem"
}