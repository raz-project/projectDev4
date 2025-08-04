🧱 Terraform AWS Infrastructure Project
Modular Deployment of a Static Website, VPC, EC2, IAM, ECR, and More
📌 Project Description
This Terraform project builds a modular AWS infrastructure for hosting a static website and deploying secure, flexible cloud components. It includes:

Static website hosting on Amazon S3

Custom VPC, subnets, Internet Gateway (IGW), and routing

Two Ubuntu EC2 instances (in separate subnets)

IAM users and policies

Security Groups (dynamically configured via Python)

Elastic Container Registry (ECR) for container storage

Each module is self-contained, reusable, and configurable via input variables.

🗂️ Project Structure
text
Copy
Edit
projectDev4/
├── first-thing-before-start/
│   └── terraformstate.tf               # Remote backend config (S3 + DynamoDB)
│
├── main.tf                             # Root module calling all submodules
├── variables.tf                        # Global project variables
├── outputs.tf                          # Aggregated outputs for quick reference
│
├── modules/
│   ├── tf-ecr/
│   │   ├── main.tf                     # Creates an ECR repository
│   │   ├── variables.tf
│   │   └── outputs.tf
│
│   ├── tf-iam-user-and-policy/
│   │   ├── main.tf                     # IAM users and custom policies
│   │   ├── variables.tf
│   │   └── outputs.tf
│
│   ├── tf-security-group/
│   │   ├── main.tf                     # Security groups (ingress/egress rules)
│   │   ├── variables.tf
│   │   └── outputs.tf
│
│   ├── tf-static-web/
│   │   ├── main.tf                     # S3 bucket with static website hosting
│   │   ├── variables.tf
│   │   └── outputs.tf
│
│   └── tf-vpc-sub-ec2/
│       ├── main.tf                     # VPC with IGW, routing, and 2 subnets
│       ├── variables.tf
│       └── outputs.tf
📡 VPC + EC2 Architecture
tf-vpc-sub-ec2 module features:
Creates a custom VPC

Adds an Internet Gateway (IGW) with routing

Provisions 2 public subnets in different AZs

Launches 2 Ubuntu EC2 instances, one in each subnet

Associates security groups, key pairs, and public IPs

🔐 IAM and Security
IAM users are created with specified access policies

Security groups are configurable via configurePolicy.py

This script dynamically adjusts rules before Terraform apply

🌐 Static Website Hosting
tf-static-web module features:
Creates an S3 bucket with:

Website hosting enabled

Public read access (properly managed with S3 policies and public access block settings)

Uploads index.html, error.html, CSS, and JS files

Outputs a public S3 website URL

📦 ECR Repository
tf-ecr module features:
Creates an Amazon ECR repository

Useful for storing container images to be used with ECS or EC2

⚙️ Setup Instructions
1️⃣ Configure Terraform Backend (only once)
Before initializing Terraform, create the S3 bucket and DynamoDB table for remote backend:

hcl
Copy
Edit
# first-thing-before-start/terraformstate.tf
terraform {
  backend "s3" {
    bucket         = "your-terraform-backend-bucket"
    key            = "projectDev4/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
⚠️ Do not destroy this backend after setup — it manages your Terraform state!

2️⃣ Initialize Terraform
bash
Copy
Edit
terraform init -backend-config=first-thing-before-start/terraformstate.tf
3️⃣ Plan and Apply Infrastructure
bash
Copy
Edit
terraform plan
terraform apply
🐍 About configurePolicy.py
This Python script customizes security group rules by accepting user input.

Usage:
bash
Copy
Edit
python configurePolicy.py --user-params
It generates Terraform-compatible JSON or variable overrides to adjust ingress/egress rules.

📤 Outputs
After deployment, Terraform provides:

✅ EC2 public and private IPs

🛡️ Security Group IDs

👤 IAM user ARNs

📦 ECR repository URLs

🌐 Static website S3 endpoint (public URL)

🧭 VPC ID, subnet IDs, and route table info

🧠 Notes
Use remote state to prevent loss of infrastructure tracking

Always review IAM and S3 policies before applying to production

Bucket public access must be explicitly unblocked in both:

aws_s3_bucket_public_access_block

AWS S3 console (if blocked at the account level)
