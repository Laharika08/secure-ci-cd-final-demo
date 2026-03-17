resource "aws_instance" "app-server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.app-sg.id]
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  monitoring                  = true
  

  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ user_data ]
  }

  tags = merge({ platform = "linux_amd64" }, {
    Name         = "${var.project_info[0]}-${var.project_info[1]}-app-server"
    Environment  = var.project_info[0]
    Client       = var.project_info[1]
    ResourceType = "EC2"
    Developer    = var.project_info[2]
  })
}
