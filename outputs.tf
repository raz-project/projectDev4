####################################################
# Static Website Outputs (tf-static)
# - Outputs related to the S3 bucket configured for static hosting
# - Includes bucket name, website endpoint, and direct file URLs
####################################################

output "bucket_name" {
  description = "The name of the created S3 bucket"
  value       = module.tf-static.bucket_name
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = module.tf-static.bucket_arn
}

output "bucket_website_endpoint" {
  description = "Public S3 website endpoint"
  value       = module.tf-static.bucket_website_endpoint
}

output "bucket_region" {
  description = "Region of the bucket"
  value       = module.tf-static.bucket_region
}

output "index_object_url" {
  description = "Direct URL to index.html"
  value       = module.tf-static.index_object_url
}

output "error_object_url" {
  description = "Direct URL to error.html"
  value       = module.tf-static.error_object_url
}

####################################################
# IAM User & Policy Outputs (tf_iam_user_and_policy)
# - Lists IAM user names, ARNs, and attached roles
####################################################

output "iam_user_names" {
  value = module.tf_iam_user_and_policy.user_names
}

output "iam_user_arns" {
  value = module.tf_iam_user_and_policy.user_arns
}

output "iam_user_roles" {
  value = module.tf_iam_user_and_policy.user_roles
}

####################################################
# EC2 Ubuntu Instance Outputs (tf-ecr)
# - Outputs from EC2 provisioning including instance IPs, names, SSH key, etc.
####################################################

output "instance_count" {
  description = "The number of EC2 instances launched from the tf-ecr module"
  value       = module.tf-ecr.instance_count
}

output "ami_used" {
  description = "AMI ID used to launch the EC2 instances"
  value       = module.tf-ecr.ami_used
}

output "ec2_public_ips" {
  description = "Public IP addresses assigned to the EC2 instances"
  value       = module.tf-ecr.ec2_public_ips
}

output "ec2_private_ips" {
  description = "Private IP addresses assigned to the EC2 instances"
  value       = module.tf-ecr.ec2_private_ips
}

output "ec2_instance_names" {
  description = "The Name tags assigned to each EC2 instance"
  value       = module.tf-ecr.ec2_instance_names
}

output "security_group_ids" {
  description = "IDs of the security groups attached to the EC2 instances"
  value       = module.tf-ecr.security_group_ids
}

output "ssh_key_name" {
  description = "The name of the SSH key pair used to access the instances"
  value       = module.tf-ecr.ssh_key_name
}

output "ssh_private_key_path" {
  description = "Path to the PEM file containing the private SSH key"
  value       = module.tf-ecr.ssh_private_key_path
}
