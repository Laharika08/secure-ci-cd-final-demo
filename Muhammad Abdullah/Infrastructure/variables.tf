# Project info
variable "env" {
  description = "The environment for the project (e.g., dev, prod, etc.)"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "developer" {
  description = "The name of the developer responsible for the project"
  type        = string
}

# VPC
variable "aws_region" {
  description = "The AWS region where resources will be provisioned"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet within the VPC"
  type        = string
}

# EC2
variable "ami_id" {
  description = "The Amazon Machine Image (AMI) ID to use for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

# Cost Management
variable "budget_name" {
  description = "Budget name."
  type        = string
}

variable "recipients" {
  description = "Recipients for notifications"
  type        = list(string)
}

variable "amount" {
  default     = "1"
  description = "Limit amount."
  type        = string
}

variable "amount_unit" {
  default     = "USD"
  description = "Limit amount unit."
  type        = string
}
