resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_route_table_cidr_block
    gateway_id = aws_internet_gateway.main.id
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [route]
  }

  tags = {
    Name         = "${var.project_info[0]}-${var.project_info[1]}-public-rt"
    Environment  = var.project_info[0]
    Client       = var.project_info[1]
    ResourceType = "Route Table (Public)"
    Developer    = var.project_info[2]
  }

}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}