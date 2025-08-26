# default VPC
data "aws_vpc" "default" {
  default = true
}

# default subnets in the VPC
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# latest Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# generate SSH key locally
resource "tls_private_key" "portfolio" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# AWS key pair
resource "aws_key_pair" "portfolio" {
  key_name   = var.key_name
  public_key = tls_private_key.portfolio.public_key_openssh
}

# Security group
resource "aws_security_group" "portfolio_sg" {
  name        = "portfolio-sg"
  description = "Allow HTTP, 8080, SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "portfolio" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnets.default_vpc_subnets.ids, 0)
  vpc_security_group_ids = [aws_security_group.portfolio_sg.id]
  key_name               = aws_key_pair.portfolio.key_name

  tags = {
    Name = "portfolio"
  }
}
