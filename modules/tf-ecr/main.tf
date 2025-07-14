provider "aws" {
  region = "us-east-1"
}

####################################################
# TLS Private Key for SSH
####################################################

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

####################################################
# AWS Key Pair using generated public key
####################################################

resource "aws_key_pair" "user_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

####################################################
# Save private key locally as PEM file
####################################################

resource "local_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0600"
}

####################################################
# Fetch Default VPC
####################################################

data "aws_vpc" "default" {
  default = true
}

####################################################
# Security Group for SSH and HTTP
####################################################

resource "aws_security_group" "web_shh" {
  count       = var.instance_count
  name        = "ssh-key-${count.index + 1}"
  description = "Allow SSH traffic and HTTP"
  vpc_id      = data.aws_vpc.default.id

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

####################################################
# Launch EC2 instances with SSH key and Security Group
####################################################

resource "aws_instance" "ubuntu_instance" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.user_key.key_name
  vpc_security_group_ids = [aws_security_group.web_shh[count.index].id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y net-tools curl openssh-server
              systemctl enable ssh
              systemctl start ssh
              systemctl restart sshd
              EOF

  tags = {
    Name = "${var.instance_name_tag}-${count.index + 1}"
  }
}
