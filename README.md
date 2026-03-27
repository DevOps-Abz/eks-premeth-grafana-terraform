# Production-Ready Deployment on Amazon EKS Using Terraform, ArgoCD , Prometheus , Grafana & ALB

A production-grade AWS EKS deployment featuring containerisation, Infrastructure as Code, GitOps practices, and secure CI/CD automation.

---

##  Project Overview

This project demonstrates a production-focused AWS deployment that applies DevOps best practices, automates infrastructure end to end, and 
enforces least-privilege security by design.

---

## Architecture

![Diagram](https://github.com/DevOps-Abz/ecs-fargate-terraform/blob/main/images/main-diagram.png)

---

## What is delpoyed?

A Flipcart application on AWS EKS demonstrating real-world DevOps and DevSecOps practices integrating ArgoCD for GitOps, Prometheus and Grafana for monitoring.
The architecture uses private node groups, NAT Gateway, Bastion Host, IAM, IRSA, and AWS Load Balancers, ensuring security, scalability, and automation. 

---

## Key Features & Implementation:

- **A scalable production-grade deployment** on AWS EKS 

- **Infrastructure as Code (IaC)** implemented using Terraform to provision and manage VPC, IAM, ECS, ALB, and related AWS resources

- **GitOps workflow** where all infra and application changes are version-controlled and applied via Git commits and pull requests

---

##  Tech Stack

### Cloud & Infrastructure

- **AWS EKS** – Run Pods in a fully managed, serverless environment

- **AWS VPC** – Network isolation subnets for public and private resources

- **AWS IAM** – Implemented IAM Role for GitHub Actions authentication via OIDC for secure, short-lived credentials

- **Application Load Balancer (ALB)** – AWS ALB Ingress Controller for traffic management, health checks, and scalability
 
---

### Infrastructure as Code (IaC)
- **Terraform** – Declarative AWS infrastructure as code with automated provisioning

---

## Project Structure
```
.
├── deployment
│   ├── amazon-deployment.yaml
│   ├── flipkart-deployment.yaml
│   ├── ingress.yaml
│   └── namespace.yml
├── README.md
└── terraform
    ├── bastion_script.sh
    ├── dev.tfvars
    ├── main.tf
    ├── modules
    │   ├── bastion
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── eks
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── helm
    │   │   ├── alb-controller-helm.tf
    │   │   ├── argocd.tf
    │   │   ├── outputs.tf
    │   │   ├── prometheus.tf
    │   │   └── variables.tf
    │   ├── iam
    │   │   ├── alb-controller-policy.tf
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── service-account
    │   │   └── alb-sa.tf
    │   ├── sg
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   └── vpc
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── outputs.tf
    ├── provider.tf
    ├── staging.tfvars
    ├── variables.tf
    └── versions.tf
```

---

## 1. Terraform Installation

```bash
# Install Terraform
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform packer git jq unzip
```

## 2. AWS CLI Installation
```bash
sudo apt install -y unzip jq
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure
```


---
