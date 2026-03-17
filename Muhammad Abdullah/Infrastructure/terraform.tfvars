# Project info
env       = "dev"
project   = "bimodal"
developer = "Muhammad Abdullah"

# VPC
aws_region  = "us-east-1"
vpc_cidr    = "10.1.0.0/20"
subnet_cidr = "10.1.1.0/24"

#EC2
ami_id        = "ami-084568db4383264d4"
instance_type = "t2.micro"

#Cost Management
budget_name = "Zero Cost Budget"
recipients  = ["muhammed.abdullah@bimodalconsulting.com"]
amount      = "1"
amount_unit = "USD"
