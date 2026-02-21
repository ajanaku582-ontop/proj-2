terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

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
  ami                  = var.ami_id
  instance_type          = "c7i-flex.large"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "App-Node"
  }
}

# Bastion Node
resource "aws_instance" "bastion" {
  ami                 = var.ami_id
  instance_type          = "c7i-flex.large"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion-Node"
  }
}

# RDS Postgres
resource "aws_db_subnet_group" "db" {
  subnet_ids = [aws_subnet.private_db1.id, aws_subnet.private_db2.id]
}

resource "aws_db_instance" "postgres" {
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "dbadmin"
  password            = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible = false
  skip_final_snapshot = true
}

