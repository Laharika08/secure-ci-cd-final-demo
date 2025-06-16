**Terraform-Powered Micro-services Infrastructure Deployment**


**Project Conceptual Diagram**
![Conceptual Diagram](<conceptual diagram-1.png>)


**Infrasture Components**
AWS Resources (Provisioned by Terraform)
1. VPC: Custom Virtual Private Cloud with public/private subnets
2. EC2 Instance: Virtual machine for CI/CD automation
3. EKS Cluster: Managed Kubernetes cluster for microservices application deployment
4. ECR: Managed container register for microservices application build images
5. S3 bucket: Simple Storage Service for remote statefile management
4. Security Groups: Network security configurations
5. NATE Gateway: Internet access for private subnets

**Microservices Architecture**
1. Frontend Service: Web interface (LoadBalancer)
2. Auth Service: Authentication API (ClusterIP)
3. Users Service: User management API (LoadBalancer)
4. Database: MongoDB Atlas (External)

**Prerequisites**
1. AWS Account with appropriate permissions
2. Jenkins server with required tools installed
3. Github repository
4. MongoDB Atlas account

**Jenkins Server Setup**
Required Tools Installation
# Install Docker
# Install Jenkins
# Install Terraform
# Install AWS CLI
# Install kubectl
# Install Node.js & NPM
# Install Trivy (Security Scanner)
# Install SonarQube Scanner
# Install Helm

**CI/CD Pipeline Stages**
1. Code checkout from repository
2. Code Quality and Security (SonarQube and Trivy Scan)
# Infrastructure Provisioning with Terraform**
1. Initializing Terraform (terraform init)
2. Formating Terraform (terraform fmt)
3. Validating Terraform (terraform validate)
4. Planning the Terraform Infra (terraform plan)
5. Creating EKS Cluster and ECR (terraform --auto-approve)
# Container Build and Push
1. Build Docker Imange
2. Login to ECR & tag image
3. Push image to ECR
4. Deploy image to EKS

# Verify deployment
---
kubectl get pods
kubectl get services
---

**Monitoring Setup**
# Install Prometheus
[Install Prometheus](https://prometheus.io/download/)

# Install Grafana
Username: admin
Password: prom-operator

Import Dashboard ID: 1860
Explore more at: https://grafana.com/grafana/dashboards/


**Cleanup**
---
# Destroy Kubernetes resources
kubectl delete -f k8s/

# Destroy Terraform infrastructure
cd terraform
terraform destroy

# Clean up Docker images
docker system prune -a
---




