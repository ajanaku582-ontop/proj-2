# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "secure-vpc"
#   }
# }

# # Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
# }

# # Public subnet (Bastion)
# resource "aws_subnet" "public" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-subnet"
#   }
# }

# # Private subnet (App)
# resource "aws_subnet" "private" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.2.0/24"

#   tags = {
#     Name = "private-subnet"
#   }
# }

# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#   subnet_id     = aws_subnet.public.id
#   allocation_id = aws_eip.nat.id
# }

# # Public route table
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_route" "public_internet" {
#   route_table_id         = aws_route_table.public.id
#   gateway_id             = aws_internet_gateway.igw.id
#   destination_cidr_block = "0.0.0.0/0"
# }

# resource "aws_route_table_association" "public_assoc" {
#   subnet_id      = aws_subnet.public.id
#   route_table_id = aws_route_table.public.id
# }

# # Private route table (via NAT)
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_route" "private_nat" {
#   route_table_id         = aws_route_table.private.id
#   nat_gateway_id         = aws_nat_gateway.nat.id
#   destination_cidr_block = "0.0.0.0/0"
# }

# resource "aws_route_table_association" "private_assoc" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.private.id
# }

# # Bastion SG
# resource "aws_security_group" "bastion_sg" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     description = "SSH from anywhere (restrict in prod)"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Change to your IP!
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # App SG (ONLY Bastion can SSH)
# resource "aws_security_group" "app_sg" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     description     = "SSH from Bastion only"
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [aws_security_group.bastion_sg.id]
#   }

#   ingress {
#     description = "App traffic (optional)"
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # DB SG
# resource "aws_security_group" "db_sg" {
#   vpc_id = aws_vpc.main.id
#   ingress {
#     from_port       = 5432
#     to_port         = 5432
#     protocol        = "tcp"
#     security_groups = [aws_security_group.app_sg.id]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_cloudwatch_log_group" "vpc_logs" {
#   name = "/vpc/flowlogs"
# }

# resource "aws_iam_role" "flow_logs_role" {
#   name = "flow_logs_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Principal = {
#         Service = "vpc-flow-logs.amazonaws.com"
#       }
#       Effect = "Allow"
#     }]
#   })
# }

# resource "aws_flow_log" "main" {
#   iam_role_arn         = aws_iam_role.flow_logs_role.arn
#   log_destination      = aws_cloudwatch_log_group.vpc_logs.arn
#   log_destination_type = "cloud-watch-logs"

#   traffic_type = "ALL"
#   vpc_id       = aws_vpc.main.id
# }

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "secure-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Public subnet (Bastion)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
}

# Private subnet (App)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"
}

# DB Subnet 1
resource "aws_subnet" "private_db1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2a"
}

# DB Subnet 2
resource "aws_subnet" "private_db2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-2b"
}

# NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat.id
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# Associate private subnets
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db1" {
  subnet_id      = aws_subnet.private_db1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db2" {
  subnet_id      = aws_subnet.private_db2.id
  route_table_id = aws_route_table.private.id
}