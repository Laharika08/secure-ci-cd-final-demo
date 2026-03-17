variable "project_info" {
  description = "Project info i.e env, project name etc"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet to place the EC2 instance in"
  type        = string
}

variable "ami_id" {
  description = "Free tier eligible ami id"
  type        = string
  default     = "ami-084568db4383264d4"
}

variable "instance_type" {
  description = "Free tier eligible instance type"
  type        = string
  default     = "t2.micro"
}