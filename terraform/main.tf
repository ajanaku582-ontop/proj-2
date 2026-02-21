provider "aws" {
  region = "us-east-2"
}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group for all instances
resource "aws_security_group" "server_sg" {
  name        = "server-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "server-sg"
  }
}

# App Node
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = "c7i-flex.large"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "App-Node"
  }
}

# Bastion Node
resource "aws_instance" "Bastion" {
  ami                    = var.ami_id
  instance_type          = "c7i-flex.large"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion-Node"
  }
}

