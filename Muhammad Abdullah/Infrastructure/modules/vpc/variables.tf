variable "project_info" {
  type = list(string)
}
variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet" {}

variable "public_route_table_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}