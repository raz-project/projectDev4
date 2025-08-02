output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.dev_vpc.id
}

output "subnet1_id" {
  description = "The ID of subnet 1"
  value       = aws_subnet.dev_subnet1.id
}

output "subnet2_id" {
  description = "The ID of subnet 2"
  value       = aws_subnet.dev_subnet2.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.dev_igw.id
}

output "route_table_id" {
  description = "The ID of the Route Table"
  value       = aws_route_table.dev_route.id
}

output "ec2_public_ips_vpc" {
  description = "Public IPs of EC2 instances in both subnets"
  value = {
    us_east_1a = aws_instance.ubuntu_instance_1_vpc.public_ip
    us_east_1b = aws_instance.ubuntu_instance_2_vpc.public_ip
  }
}

output "private_key_path" {
  description = "Path to the generated private key file"
  value       = local_file.private_key_pem.filename
}

output "igw_name" {
  description = "The name of the Internet Gateway"
  value       = var.igw_name
}

output "route_table_name" {
  description = "The name of the Route Table"
  value       = var.route_table_name
}
