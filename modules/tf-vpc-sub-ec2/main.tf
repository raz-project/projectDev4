# Define the provider
provider "aws" {
  region = var.region
}

# Generate a TLS private key for SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS Key Pair using the generated public key
resource "aws_key_pair" "user_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save the private key locally as a PEM file
resource "local_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0600"
}

# Create the VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create subnet in us-east-1a
resource "aws_subnet" "dev_subnet1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet1_name
  }
}

# Create subnet in us-east-1b
resource "aws_subnet" "dev_subnet2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet2_name
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = var.igw_name
  }
}

# Create a Route Table
resource "aws_route_table" "dev_route" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    Name = var.route_table_name
  }
}

# Associate the Route Table with Subnets
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.dev_subnet1.id
  route_table_id = aws_route_table.dev_route.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.dev_subnet2.id
  route_table_id = aws_route_table.dev_route.id
}

# Launch EC2 instances in subnets
resource "aws_instance" "ubuntu_instance_1_vpc" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.user_key.key_name
  vpc_security_group_ids      = [aws_security_group.web_shh_vpc.id]
  subnet_id                   = aws_subnet.dev_subnet1.id
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install -y net-tools curl openssh-server
                systemctl enable ssh
                systemctl start ssh
                systemctl restart ssh
              EOF

  tags = {
    Name = "${var.instance_name_tag}-1"
  }
}

resource "aws_instance" "ubuntu_instance_2_vpc" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.user_key.key_name
  vpc_security_group_ids      = [aws_security_group.web_shh_vpc.id]
  subnet_id                   = aws_subnet.dev_subnet2.id
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install -y net-tools curl openssh-server
                systemctl enable ssh
                systemctl start ssh
                systemctl restart ssh
              EOF

  tags = {
    Name = "${var.instance_name_tag}-2"
  }
}

# Create a Security Group allowing SSH and HTTP traffic
resource "aws_security_group" "web_shh_vpc" {
  name        = "ssh-key-vpc-dev"
  description = "Allow SSH traffic and HTTP"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
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
}
