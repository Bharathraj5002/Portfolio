# Sample Web Portfolio Deployment on AWS EC2

Deploy a sample web portfolio on **AWS EC2** using **Docker**, **Docker Compose**, **Terraform**, and **GitHub Actions**. Demonstrates a complete **CI/CD pipeline** with infrastructure as code.

***

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Terraform Deployment](#terraform-deployment)
- [Docker Setup](#docker-setup)
- [GitHub Actions Configuration](#github-actions-configuration)
- [Accessing the Application](#accessing-the-application)
- [Troubleshooting](#troubleshooting)
- [Notes](#notes)
- [License](#license)

***

## Project Overview

This repository contains:

- A sample web portfolio application
- **Dockerfile** for containerization
- **Terraform scripts** to provision AWS EC2 and security groups
- **GitHub Actions workflow** for automated CI/CD pipeline

Once deployed, access your application via EC2 public IP on port **8080**.

***

## Prerequisites

Before getting started, ensure you have:

- **Git**
- **Docker**
- **Terraform**
- AWS account with rights to create EC2 and security groups
- **AWS CLI** configured (`aws configure`)

***

## Setup Instructions

### 1. Clone the Repository

```bash
(https://github.com/Bharathraj5002/Portfolio.git)
cd Portfolio
```


### 2. Configure AWS CLI

```bash
aws configure
```

Provide:

- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., us-east-1)
- Default output format (json)

***

## Terraform Deployment

Terraform provisions EC2 and security group resources.

- **Change to Terraform:**

```bash
cd terraform
```

- **Initialize Terraform:**

```bash
terraform init
```

- **Preview planned resources:**

```bash
terraform plan
```

- **Apply configuration:**

```bash
terraform apply
```


Type `yes` when prompted. Note the EC2 public IP from the output.

***


## Docker Setup (Manual Deployment)

Terraform will create the `portfolio.pem` file (private key). Make sure it's in your local directory.
- **Update permissions for the key file:**

```bash
chmod 400 portfolio.pem
```

- **SSH into your EC2 instance:**

```bash
ssh -i portfolio.pem ec2-user@<EC2_PUBLIC_IP>
```

- **Install Docker on the EC2 instance (Ubuntu):**

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo docker --version
```

- **Pull and run the portfolio Docker image from Docker Hub:**

```bash
sudo docker run -d -p 8080:80 bharathraj5002/portfolio:latest
sudo docker ps
```


Your application should now be available at:
`http://<EC2_PUBLIC_IP>:8080`

***



## GitHub Actions Configuration

Automate deployment with GitHub Actions:

- Go to your GitHub repository → **Settings > Secrets and variables > Actions**.
- Add the following secrets:
    - `DOCKER_USERNAME` — Docker Hub username
    - `DOCKER_PASSWORD` — Docker Hub password
    - `EC2_PUBLIC_IP` — EC2 public IP
    - `EC2_SSH_PRIVATE_KEY` — SSH key contents for EC2

Push code changes; workflow will:

- Build Docker image
- Push to Docker Hub
- SSH into EC2, pull/run image with Docker Image

***

## Accessing the Application

Open a browser and visit:

```
http://<EC2_PUBLIC_IP>:8080
```

You should see your web portfolio.

***

## Troubleshooting

- **Terraform errors:** Check AWS credentials and IAM permissions.
- **SSH issues:** Ensure key permissions (`chmod 400 key.pem`), and port 22 is allowed.
- **Docker issues:** Check logs:

```bash
docker <Image_name> logs
```

- **Port/firewall issues:** Make sure security group allows inbound traffic on port 80.

***

## Notes

- Always use your own GitHub repository for GitHub Actions to function.
- Ensure all secrets are set correctly.
- Docker must be installed on your EC2 instance.
- Run Terraform once per deployment unless destroying/recreating the instance.

***

## License

This project is open-source and licensed under the **MIT License**.
