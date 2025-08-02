####################################################
# Terraform Backend Configuration
# - Stores the Terraform state in S3
# - Enables remote state storage and locking
####################################################

terraform {
  backend "s3" {
    bucket = "tf-state-s3-buc"
    key    = "state/dev_ops/terraform.tfstate"
    region = "us-east-1"
  }
}

####################################################
# AWS Provider Configuration
# - Required for all AWS resources
####################################################

provider "aws" {
  region = "us-east-1"
}

####################################################
# Static Website Module (S3)
# - Creates a public S3 bucket with website hosting
# - Uploads index.html and error.html
# - Outputs include bucket URLs and website endpoints
####################################################

module "tf-static" {
  source      = "./modules/tf-static-web"
  bucket_name = "new-static-123"
}

####################################################
# IAM User + Policy Module
# - Creates IAM users with attached policies
# - Outputs user names, ARNs, and roles
####################################################

module "tf_iam_user_and_policy" {
  source = "./modules/tf-iam-user-and-policy"
}

####################################################
# EC2 Ubuntu Server Module (tf-ecr)
# - Launches Ubuntu EC2 instances using a key pair
# - Automatically provisions SSH access and installs tools
# - Outputs instance IPs, security groups, SSH key path, and more
####################################################

module "tf-ecr" {
  source            = "./modules/tf-ecr"
  key_name          = "project_dev_key"
  instance_count    = 2
  ami               = "ami-020cba7c55df1f615"
  instance_type     = "t2.micro"
  instance_name_tag = "my_custom_server"
}


####################################################
# VPC with EC2 Instances, Subnets, and Routing Module
# - Creates a VPC with two subnets in different availability zones
# - Creates an Internet Gateway (IGW) and attaches it to the VPC
# - Creates a route table and associates it with the subnets
# - Launches EC2 instances in both subnets with SSH access using PEM key generated via TLS
# - Outputs VPC, subnet IDs, EC2 instance IPs, and other useful information
####################################################

module "tf-vpc-sub-ec2" {
  source            = "./modules/tf-vpc-sub-ec2"
  key_name          = "project_dev_vpc"          # Example value for SSH Key
  instance_count    = 2                          # Example value for instance count
  ami               = "ami-020cba7c55df1f615"    # Example value for the AMI
  instance_name_tag = "raz_vpc-sub-ec2-instance" # Example value for instance name tag
  vpc_name          = "dev-vpc"                  # Example VPC name
  subnet1_cidr      = "10.0.0.0/24"              # Example subnet CIDR for subnet 1
  subnet2_cidr      = "10.0.1.0/24"              # Example subnet CIDR for subnet 2
  region            = "us-east-1"                # Example region
  igw_name          = "Dev-IGW"                  # Example IGW name
  route_table_name  = "dev-route"                # Example route table name
}

####################################################
# Reminder: Custom Security Group Policy
# - Local script hint to configure additional SG settings
# - Manually run 'python configurePolicy.py' if needed
####################################################

resource "null_resource" "reminder_to_run_script" {
  provisioner "local-exec" {
    command = "echo 'Reminder: Enter the tf-security-group directory and run: python configurePolicy.py'"
  }

  triggers = {
    always_run = timestamp()
  }
}

####################################################
# Final Outputs Printed After Apply
# - Refer to outputs.tf for output configuration
####################################################
