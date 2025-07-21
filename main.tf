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
  bucket_name = "web-static-bucket-addres"
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
