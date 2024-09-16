# AWS Infrastructure Terraform Module

This Terraform module sets up a comprehensive AWS infrastructure including VPC, ECR, ACM, RDS MySQL, Load Balancer, and ECS services. It's designed to create a scalable and secure environment for deploying containerized applications.

## Table of Contents

1. [Features](#features)
2. [Prerequisites](#prerequisites)
3. [Usage](#usage)
4. [Module Structure](#module-structure)
5. [Inputs](#inputs)
6. [Outputs](#outputs)
7. [Submodules](#submodules)
8. [Notes](#notes)

## Features

- VPC setup with customizable AZ count and CIDR block
- ECR repository for Docker images
- ACM certificate management
- RDS MySQL database
- Application Load Balancer
- ECS cluster and service deployment with autoscaling capabilities
- Secrets management using HashiCorp Vault

## Prerequisites

- Terraform v0.12+
- AWS CLI configured with appropriate credentials
- HashiCorp Vault setup with the necessary secrets

## Usage

1. Clone this repository or copy the module files into your Terraform project.

2. Log in to HashiCorp Vault using the GitHub method:

```
vault login -method=github -path=github
```

3. Export the Vault token and account id as an environment variable:

```
export TF_VAR_vault_token=<token>
export tf_VAR_account_id=<account id>
```

4. Create a `main.tf` file in your project root and use the module as follows:

```hcl
module "aws_infrastructure" {
  source = "./path/to/module"

  # VPC
  az_count = 2
  vpc_cidr = "10.0.0.0/16"

  # ECR
  ecr_name     = "my-ecr-repo"
  force_delete = true

  # ACM
  domain_name = "example.com"

  # RDS MySQL
  publicly_accessible = false
  port                = 3306
  deletion_protection = false
  db_instance_class   = "db.t3.micro"
  db_name             = "mydb"
  engine_version      = "8.0"
  multi_az            = false

  # ECS
  account_id = "your-aws-account-id"

  # Other variables as needed
}
```

5. Initialize Terraform:
   ```
   terraform init -reconfigure -backend-config=./dev-backend.conf
   ```

6. Plan and apply the changes:
   ```
   terraform plan -var-file=./vars/dev.tfvars 
   terraform apply -var-file=./vars/dev.tfvars 
   ```

## Module Structure

The main module orchestrates several submodules:

- `vpc`: Sets up the VPC, subnets, and related networking components
- `ecr`: Creates an Elastic Container Registry repository
- `acm`: Manages SSL/TLS certificates using AWS Certificate Manager
- `mysql`: Sets up an RDS MySQL instance
- `lb`: Configures an Application Load Balancer
- `ecs`: Sets up ECS cluster, task definitions, and services

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| az_count | Number of Availability Zones to use | number | yes |
| vpc_cidr | CIDR block for the VPC | string | yes |
| ecr_name | Name of the ECR repository | string | yes |
| force_delete | Whether to force delete the ECR repository | bool | yes |
| domain_name | Domain name for the ACM certificate | string | yes |
| publicly_accessible | Whether the RDS instance should be publicly accessible | bool | yes |
| port | Port for the RDS instance | number | n/a | yes |
| deletion_protection | Whether deletion protection is enabled for RDS | bool | yes |
| db_instance_class | Instance class for the RDS instance | string | yes |
| db_name | Name of the database to create | string | yes |
| engine_version | Version of MySQL to use | string | yes |
| multi_az | Whether to enable multi-AZ for RDS | bool | yes |
| account_id | Your AWS account ID | string | yes |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| repository_url | The URL of the created ECR repository |
| repository_arn | The ARN (Amazon Resource Name) of the created ECR repository |
| alb_arn | The ARN of the Application Load Balancer |
| alb_dns | The DNS name of the Application Load Balancer |
| certificate_arn | The ARN of the SSL/TLS certificate created in ACM |
| db_endpoint | The connection endpoint for the RDS database instance |
| ecs_service | Details of the created ECS service |

These outputs provide essential information about the resources created by the module:

- `repository_url` and `repository_arn`: Use these to push and manage Docker images in the created ECR repository.
- `alb_arn` and `alb_dns`: The ALB's ARN can be used for further configuration, while the DNS name is what you'll use to access your application.
- `certificate_arn`: This is useful if you need to associate the SSL/TLS certificate with other AWS resources.
- `db_endpoint`: Use this to connect to your RDS database instance.
- `ecs_service`: Provides details about the deployed ECS service, which can be useful for monitoring and management.

## Submodules

Each submodule (`vpc`, `ecr`, `acm`, `mysql`, `lb`, `ecs`) has its own set of inputs and outputs. Refer to the individual module documentation for details.

## Notes

- This module uses HashiCorp Vault to manage database credentials. Ensure that Vault is properly configured and accessible.
- The ECS service is set up to use the latest image from the specified ECR repository. Make sure to push your application image to this repository.
- The module sets up a single ECS service named "prehire-service". Modify the `services` map in the `ecs` module call if you need to deploy multiple services.
- SSL/TLS termination is handled at the load balancer level. Ensure that your domain's DNS is properly configured to point to the ALB's DNS name.
- The RDS instance is created in the public subnets by default. Consider moving it to private subnets for enhanced security in production environments.
