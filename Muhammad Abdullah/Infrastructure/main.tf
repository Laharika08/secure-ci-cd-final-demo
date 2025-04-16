provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr
  public_subnet  = var.subnet_cidr

  project_info = [
    var.env,
    var.project,
    var.developer
  ]
}

module "ec2" {
  source = "./modules/ec2"

  subnet_id     = module.vpc.public_subnet_id
  ami_id        = var.ami_id
  instance_type = var.instance_type

  project_info = [
    var.env,
    var.project,
    var.developer
  ]
}

module "cost-management" {
  source = "./modules/cost-management"

  name = "BiModal PreHire"
  recipients = var.recipients
  
  budgets = [
    {
      name = var.budget_name

      budget_type  = "COST"
      limit_amount = var.amount
      limit_unit   = var.amount_unit

      time_period_start = "2025-04-07_00:00"
      time_period_end   = "2025-04-30_00:00"
      time_unit         = "MONTHLY"

      notification = {
        comparison_operator = "GREATER_THAN"
        threshold           = "10"
        threshold_type      = "PERCENTAGE"
        notification_type   = "FORECASTED"
      }
    }
  ]

  project_info = [
    var.env,
    var.project,
    var.developer
  ]
}
