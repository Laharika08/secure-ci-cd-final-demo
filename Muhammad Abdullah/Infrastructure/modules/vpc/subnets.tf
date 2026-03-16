resource "aws_subnet" "public" {

  cidr_block = var.public_subnet
  vpc_id     = aws_vpc.main.id

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name         = "${var.project_info[0]}-${var.project_info[1]}-public"
    Environment  = var.project_info[0]
    Client       = var.project_info[1]
    ResourceType = "Subnet (Public)"
    Developer    = var.project_info[2]
  }
}