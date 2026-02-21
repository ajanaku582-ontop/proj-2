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

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "c7i-flex.large"
  subnet_id                   = aws_subnet.public.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Bastion"
  }
}

resource "aws_instance" "app" {
  ami                   = var.ami_id
  instance_type          = "c7i-flex.large"
  subnet_id              = aws_subnet.private.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  associate_public_ip_address = false

  tags = {
    Name = "App"
  }
}

resource "aws_db_subnet_group" "db" {
  name = "db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db1.id,
    aws_subnet.private_db2.id
  ]
}

resource "aws_db_instance" "postgres" {
  engine         = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = 20

  username = "dbadmin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
}

