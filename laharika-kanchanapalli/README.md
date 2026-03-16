Secure CI/CD Pipeline Project

This repository demonstrates a secure DevSecOps CI/CD pipeline for a lightweight Python FastAPI service. The pipeline integrates automated security checks, policy validation, container image signing, and prepares the application for deployment to Kubernetes.

The goal of this project is to show how security can be integrated throughout the CI/CD lifecycle.

**Repository Structure**
Path	Purpose
app/main.py	FastAPI application exposing health and build-info endpoints
requirements.txt	Python dependencies
Dockerfile	Container build instructions
policy/security.rego	OPA policy blocking the use of :latest container image tags
config/deployment.yaml	Kubernetes deployment manifest
.github/workflows/secure-ci-cd.yml	CI/CD pipeline configuration
demo_instructions.md	Steps to run and demonstrate the pipeline
Application Overview

The FastAPI Secure Build Info API is a small service used to demonstrate the secure pipeline.

**The application exposes two endpoints:**

/ - Health check endpoint returning the service status.

/build-info - Returns metadata about the build including:

Application version

Build ID

Deployment environment

Security validation status

Build timestamp

These values are provided through environment variables during deployment.

Security Controls Implemented

The CI/CD pipeline includes several security layers:

SAST – Static code analysis using Semgrep

Secrets scanning – Detection of leaked credentials using Gitleaks

SCA & container scanning – Dependency and container vulnerability scanning using Trivy

Policy as Code – Kubernetes manifest validation using OPA / Conftest

Artifact signing – Container image signing using Cosign

The OPA policy prevents Kubernetes deployments from using the :latest image tag, ensuring deterministic deployments.

Requirements

To run the project locally you need:

Docker (20.10 or later)

kubectl configured for a Kubernetes cluster

Python 3.10+ (optional for running without Docker)

Conftest (optional for manual policy validation)

Running the Application Locally

Install dependencies:

pip install -r requirements.txt

Run the FastAPI service:

export APP_VERSION=0.1.0
export BUILD_ID=local
export DEPLOYMENT_ENV=dev
export SECURITY_STATUS=pass
export BUILD_TIMESTAMP=$(date -Iseconds)

uvicorn app.main:app --reload --port 8000
Build and Run the Container

Build the image:

docker build -t fastapi-secure-demo:0.1.0 .

Run the container:

docker run --rm -p 8000:8000 \
  -e APP_VERSION=0.1.0 \
  -e BUILD_ID=$(git rev-parse --short HEAD) \
  -e DEPLOYMENT_ENV=local \
  -e SECURITY_STATUS=pass \
  -e BUILD_TIMESTAMP=$(date -Iseconds) \
  fastapi-secure-demo:0.1.0
Deploy to Kubernetes

Update the container image in:

config/deployment.yaml

Then deploy the application:

kubectl apply -f config/deployment.yaml
CI/CD Pipeline Workflow

The GitHub Actions pipeline performs the following steps:

1. Trigger pipeline on code push

2. Run security scans (Semgrep, Gitleaks, Trivy)

3. Validate Kubernetes policies using OPA/Conftest

4. Build Docker container image

5. Sign container image using Cosign

6. Prepare artifact for secure deployment


