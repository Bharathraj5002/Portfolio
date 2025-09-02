# Sample Web Portfolio Deployment on AWS EC2

This project is a **sample web portfolio** that can be deployed on **AWS EC2** using **Docker**, **Docker Compose**, **Terraform**, and **GitHub Actions**. It demonstrates a complete CI/CD workflow with infrastructure as code.

---

## Table of Contents

- [Project Overview](#project-overview)  
- [Prerequisites](#prerequisites)  
- [Setup Instructions](#setup-instructions)  
- [Terraform Deployment](#terraform-deployment)  
- [GitHub Actions Configuration](#github-actions-configuration)  
- [Accessing the Application](#accessing-the-application)  
- [Notes](#notes)  
- [License](#license)  

---

## Project Overview

This repository contains:  

- A **sample web portfolio** application  
- **Dockerfile** to containerize the application  
- **docker-compose.yml** for multi-container setup  
- **Terraform scripts** for provisioning an AWS EC2 instance  
- **GitHub Actions workflow** to automate deployment  

The workflow allows you to push your code and automatically deploy it to AWS EC2 using Docker.

---

## Prerequisites

Before you begin, ensure you have the following installed and configured:

- [Git](https://git-scm.com/)  
- [Docker](https://www.docker.com/)  
- [Docker Compose](https://docs.docker.com/compose/)  
- [Terraform](https://developer.hashicorp.com/terraform)  
- An **AWS account** with access keys  

---

## Setup Instructions

1. **Clone the repository**  

git clone https://github.com/<your-username>/<repo-name>.git
cd <repo-name>
Configure AWS CLI

bash
Copy code
aws configure
Provide your AWS Access Key, Secret Key, region, and output format.

Initialize and Apply Terraform

bash
Copy code
terraform init
terraform plan
terraform apply
This will provision an EC2 instance and configure the necessary infrastructure.

GitHub Actions Configuration
To enable automatic deployment via GitHub Actions, set the following repository secrets:

DOCKER_USERNAME – Your Docker Hub username

DOCKER_PASSWORD – Your Docker Hub password

EC2_PUBLIC_IP – Public IP of your EC2 instance

EC2_SSH_PRIVATE_KEY – Private key for SSH access to your EC2 instance

Make sure you use your own credentials.

Once the secrets are configured, pushing to your repository will trigger the workflow and deploy your application automatically.

Accessing the Application
After a successful GitHub Actions deployment, access your application at:

cpp
Copy code
http://<EC2_PUBLIC_IP>:80
Open the URL in your browser to see your deployed web portfolio.

Notes
You must push the repository to your own GitHub account.

Ensure you have valid AWS credentials and proper IAM permissions for EC2.

Deployment relies on Docker and Docker Compose installed on the EC2 instance.

License
This project is open-source and available under the MIT License.
