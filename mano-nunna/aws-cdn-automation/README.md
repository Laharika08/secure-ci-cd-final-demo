# Automated AWS CDN Creation for Customers

This project automates the creation of AWS CDN endpoints for multiple customers, leveraging Terraform for infrastructure provisioning and AWS Step Functions for orchestration. Each customer will have their own DNS, and this solution includes automatic ACM certificate request and validation, CDN creation, and notification to customers about the CDN status.

## Overview

The automation handles the following tasks:

- **Terraform** is used to provision the AWS infrastructure, including S3 buckets for CDN sources, Lambda functions for ACM certificate requests, and the necessary IAM roles, CloudWatch log groups, and other dependencies.
- **AWS Step Functions** orchestrates the workflow to:
  - Create a CloudFront distribution (CDN)
  - Request an ACM certificate for a domain (e.g., `cdn.example.com`)
  - Notify customers to add CNAME records to their DNS
  - Validate ACM certificates and associate them with the CDN
  - Update Route 53 with the alias record for the CDN
  - Notify customers that the CDN is ready and accessible

### Prerequisites

- AWS Account
- Terraform installed
- Access to AWS Step Functions
- Knowledge of AWS Lambda, ACM, Route 53, and CloudFront

### Setup and Deployment

1. **Navigate to the Project Directory**

```bash
cd aws-cdn-automation
```
### 2. Terraform Initialization and Apply

```bash
terraform init
terraform apply
```

### 3.Review the Step Functions State Machine

Examine the AWS Step Functions state machine definition to understand the workflow steps.

### 4. Execute the State Machine

Start the state machine execution for each customer to begin the CDN creation process.