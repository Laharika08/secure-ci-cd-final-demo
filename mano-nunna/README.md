# BiModal <> Mano Nunna - Pre-hire demo

# Repository Structure for Demo Projects

This repository contains two main demo projects focusing on integration between Kubernetes and HashiCorp Vault, and automating the creation of AWS CDN using Terraform and AWS Step Functions. Below is the structure and naming convention used in this repository to facilitate ease of access and clarity.

## Projects Overview

- `k8s-vault-integration`: Demonstrates the integration of Kubernetes with HashiCorp Vault, covering aspects such as authentication, service accounts, roles, permissions, and secret management.
- `aws-cdn-automation`: Focuses on automating the creation of AWS CDN and its components using Terraform for provisioning and AWS StepFunctions for orchestration.

## Project Details

### Kubernetes and HashiCorp Vault Integration (`k8s-vault-integration`)

This project guides you through setting up HashiCorp Vault with Kubernetes for secure secrets management. Key features include:
- Configuring Vault with Kubernetes authentication.
- Setting up service accounts with necessary roles and permissions.
- Writing and accessing secrets within Vault from Kubernetes pods.

For detailed documentation, please refer to the `k8s-vault-integration` directory.

### Automate AWS CDN Creation (`aws-cdn-automation`)

This project automates the provisioning of AWS CDN and its components using Terraform and AWS StepFunctions. It includes:
- Terraform scripts for AWS infrastructure provisioning.
- AWS StepFunctions to automate the workflow for creating AWS CDN and its components.

For detailed documentation, please refer to the `aws-cdn-automation` directory.

## Naming Convention

- Directories are named using lowercase and dashes to separate words for readability, reflecting the key technologies or platforms used.
- Documentation within each project directory follows a `README.md` format for ease of access on platforms like GitHub.

## How to Use This Repository

1. Clone the repository to your local machine.
2. Navigate to the project directory of interest (`k8s-vault-integration` or `aws-cdn-automation`).
3. Follow the `README.md` instructions within the chosen directory to start with the demo project.

We recommend reviewing the documentation provided in each project directory to understand the setup and deployment processes fully.
