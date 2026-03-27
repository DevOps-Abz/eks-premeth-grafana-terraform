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

## 3. Kubectl installtion Configuration
```bash
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

sudo apt-get update
sudo apt-get install -y kubectl bash-completion

# Enable kubectl auto-completion
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc

# Apply changes immediately
source ~/.bashrc
```
## 4. EKSCTL Installtion
```bash
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

# Install bash completion
sudo apt-get install -y bash-completion

# Enable eksctl auto-completion
echo 'source <(eksctl completion bash)' >> ~/.bashrc
echo 'alias e=eksctl' >> ~/.bashrc
echo 'complete -F __start_eksctl e' >> ~/.bashrc

# Apply changes immediately
source ~/.bashrc
```
## 5. Helm Installation
```bash
sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm bash-completion

# Enable Helm auto-completion
echo 'source <(helm completion bash)' >> ~/.bashrc
echo 'alias h=helm' >> ~/.bashrc
echo 'complete -F __start_helm h' >> ~/.bashrc

# Apply changes immediately
source ~/.bashrc

terraform destroy -var-file="dev.tfvars" -auto-approve
terraform destroy -var-file="stage.tfvars" -auto-approve
terraform destroy -var-file="prod.tfvars" -auto-approve
```

## 6. EKS Cluster Setup 
```bash
aws configure
aws sts get-caller-identity
```

## 7. Terraform Apply
```bash
tf apply -var-file=dev.tfvars -auto-approve
```

## 8. Install EKS Addons version check
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm search repo eks/aws-load-balancer-controller --versions
helm list -A
```

## 9. Install EKS Addons argo-cd version check
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm search repo argo/argo-cd --versions
helm list -A
```

## 10. Install EKS Addons prometheus version check
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update prometheus-community
helm search repo prometheus-community/kube-prometheus-stack --versions
helm list -A
```

## 11. Update the kubeconfig
```bash
aws eks update-kubeconfig --name testing-my-cluster --region ea-east-1
```

## 12. Get the argocd server url
```bash
kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'
```

## 13. Get the argocd admin password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## 14. Get the prometheus admin password
```bash
kubectl get secret --namespace prometheus prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## 15. Get the prometheus grafana image
```bash
helm list -n prometheus
kubectl get pods -n prometheus -l app.kubernetes.io/name=grafana -o jsonpath='{.items[*].spec.containers[*].image}'
```

## 16. Reset the prometheus grafana admin password
```bash
kubectl exec --namespace prometheus -it $(kubectl get pods --namespace prometheus -l app.kubernetes.io/name=grafana -o jsonpath="{.items[0].metadata.name}") -- grafana-cli admin reset-admin-password Abcd@1234
```

## 17. Delete the Deployments
```bash
kubectl delete -f .
```

## 18. Destory the infrastructure
```bash
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars" -auto-approve
terraform destroy -var-file="dev.tfvars" -auto-approve

eksctl delete cluster --name testing-my-cluster --region ap-south-1


terraform destroy -var-file="stage.tfvars" -auto-approve
terraform destroy -var-file="prod.tfvars" -auto-approve.
```

