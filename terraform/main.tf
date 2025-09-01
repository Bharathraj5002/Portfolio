
# Generate an SSH key pair in Terraform (kept in state)
resource "tls_private_key" "portfolio" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "portfolio" {
  key_name   = "portfolio"
  public_key = tls_private_key.portfolio.public_key_openssh
}

# Save the private key to a .pem file locally
resource "local_file" "portfolio_private_key" {
  content  = tls_private_key.portfolio.private_key_pem
  filename = "${path.module}/portfolio.pem"
  file_permission = "0600"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Create a security group
resource "aws_security_group" "portfolio_sg" {
  name        = "portfolio-sg"
  description = "Allow HTTP, 8080, SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow custom 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "portfolio-sg"
  }
}

# Get all subnets in default VPC
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Ubuntu AMI (latest for us-east-2)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Create EC2 instance
resource "aws_instance" "portfolio" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = element(data.aws_subnets.default_vpc_subnets.ids, 0)
  vpc_security_group_ids = [aws_security_group.portfolio_sg.id]
  key_name               = aws_key_pair.portfolio.key_name
  # Install dependencies (Docker)
  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              apt-get update -y

              # Install Docker from Ubuntu repo
              apt-get install -y docker.io

              # Enable & start Docker
              systemctl enable docker
              systemctl start docker

              # Allow ubuntu user to run Docker without sudo
              usermod -aG docker ubuntu
              EOF
  tags = {
    Name = "portfolio"
  }
}
