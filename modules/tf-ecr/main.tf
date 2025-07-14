provider "aws" {
  region = "us-east-1"
}



# Generate a TLS private key for SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS Key Pair using the generated public key
resource "aws_key_pair" "user_key" {
  key_name   = var.key_name # Use the variable defined in variables.tf
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save the private key locally as a PEM file
resource "local_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0600"
}

# Fetch the default VPC in the region
data "aws_vpc" "default" {
  default = true
}


# Create a Security Group allowing SSH and HTTP traffic
resource "aws_security_group" "web_shh" {
  count       = var.instance_count           # Add dynamic security groups if multiple instances
  name        = "ssh-key-${count.index + 1}" # Dynamically set the name for each SG
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

# Launch EC2 instances with the specified security group and SSH key
resource "aws_instance" "ubuntu_instance" {
  count                  = var.instance_count # Dynamically set the number of instances
  ami                    = var.ami            # Dynamically set the AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.user_key.key_name
  vpc_security_group_ids = [aws_security_group.web_shh[count.index].id] # Link dynamic SG with instance

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
    Name = "${var.instance_name_tag}-${count.index + 1}" # Dynamically set instance name tag
  }
}

# Output the public IPs of all EC2 instances
output "ec2_public_ips" {
  description = "Public IPs of EC2 instances"
  value       = [for instance in aws_instance.ubuntu_instance : instance.public_ip]
}

# Output the path to the saved private key
output "private_key_path" {
  description = "Path to the generated private key file"
  value       = local_file.private_key_pem.filename
}
