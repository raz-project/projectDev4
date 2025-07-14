#################################################
#                    OUTPUTS                    #
#################################################

output "instance_count" {
  description = "Number of EC2 instances launched"
  value       = var.instance_count
}

output "ami_used" {
  description = "AMI ID used for launching EC2 instances"
  value       = var.ami
}

output "ec2_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = [for instance in aws_instance.ubuntu_instance : instance.public_ip]
}

output "ec2_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = [for instance in aws_instance.ubuntu_instance : instance.private_ip]
}

output "ec2_instance_names" {
  description = "List of EC2 instance names"
  value       = [for i in range(var.instance_count) : "${var.instance_name_tag}-${i + 1}"]
}

output "security_group_ids" {
  description = "List of Security Group IDs"
  value       = [for sg in aws_security_group.web_shh : sg.id]
}

output "ssh_key_name" {
  description = "Name of the SSH Key Pair"
  value       = aws_key_pair.user_key.key_name
}

output "ssh_private_key_path" {
  description = "Local path to the private SSH key PEM file"
  value       = local_file.private_key_pem.filename
}
