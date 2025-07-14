# projectDev4

Terraform AWS Infrastructure Project: Static Website Deployment
Project Description
This Terraform project deploys a static website to AWS S3 and provisions the required AWS infrastructure components using modular and reusable Terraform code. The project includes multiple modules such as EC2 instance setup, IAM users and policies, security groups, Elastic Container Registry (ECR), and static web hosting.

The infrastructure is fully customizable via variables, enabling flexible deployments and user-specific configurations, including security groups tailored through a companion Python script (configurePolicy.py). Outputs provide convenient access to deployed resources like public IPs and S3 URLs.

Project Structure
plaintext
Copy
Edit
projectDev4/
├── first-thing-before-start/
│   └── terraformstate.tf               # Remote backend config (S3 + DynamoDB)
│
├── main.tf                            # Calls all modules and resources
├── variables.tf                       # Project-level variables
├── outputs.tf                         # Aggregated outputs from modules
├── terraform.tfstate                  # Terraform state file (local or remote)
│
├── modules/
│   ├── tf-ecr/                        # ECR repository module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── tf-iam-user-and-policy/        # IAM users and policies module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── tf-security-group/              # Security group module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── tf-static-web/                  # Static website hosting module (S3)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
Terraform Version
Tested with Terraform v1.x.x (replace with your exact version).

Setup Instructions
Create the Terraform Backend Bucket
Before running Terraform, manually create an S3 bucket and DynamoDB table to use as a remote backend for state locking and management.
This bucket is used in first-thing-before-start/terraformstate.tf.

Important: After setup and initial apply, remove or destroy this folder/resource to avoid accidental deletion of the backend bucket which holds your Terraform state.

Initialize Terraform
From the project root:

bash
Copy
Edit
terraform init -backend-config=first-thing-before-start/terraformstate.tf
Run Terraform Plan and Apply

bash
Copy
Edit
terraform plan
terraform apply
Inputs and Outputs
Input variables are defined in variables.tf files across modules and the root.

Outputs include:

EC2 instance public and private IPs

Security Group IDs

IAM user ARNs

ECR repository URLs

Static website S3 bucket URLs

These outputs help you connect to and verify deployed resources easily.

About configurePolicy.py
This Python script accepts user parameters to dynamically customize security groups by adding specific ingress and egress rules. It integrates with the Terraform deployment process to generate policy inputs used by the security group module.

Usage example:

bash
Copy
Edit
python configurePolicy.py --user-params <params>
Application Overview
The deployed application is a static website hosted on an S3 bucket with public access enabled. Users can customize security groups and IAM users to control access and permissions. The output of the Terraform deployment provides URLs and IPs to access the resources, making verification straightforward.

Version Control
This entire project is maintained in a remote GitHub repository for version control, collaboration, and CI/CD integration.

Notes
Always backup or export your Terraform state files before destroying the backend bucket. Destroying the backend bucket will delete your state, causing potential loss of infrastructure tracking.

Customize variables to suit your environment and needs before running Terraform commands.
