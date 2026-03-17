resource "aws_security_group" "app-sg" {
  name        = "${var.project_info[0]}-${var.project_info[1]}-app-ec2-sg"
  description = "Used to allow application traffic and SSH for debugging purposes"
  vpc_id      = data.aws_subnet.default.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
