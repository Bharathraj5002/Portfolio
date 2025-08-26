variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "portfolio"   # user requested keypair name "portfolio"
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"   # CHANGE this to YOUR_IP/32 for security
  description = "CIDR allowed for SSH (set to your IP/32 in prod)"
}

variable "docker_image" {
  type    = string
  default = "bharathraj5002/portfolio:latest"
}
