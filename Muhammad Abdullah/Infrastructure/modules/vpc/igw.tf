resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name         = "${var.project_info[0]}-${var.project_info[1]}-igw"
    Environment  = var.project_info[0]
    Client       = var.project_info[1]
    ResourceType = "IGW"
    Developer    = var.project_info[2]
  }

}