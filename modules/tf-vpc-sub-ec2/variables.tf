variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "project_dev_vpc"
}

variable "instance_count" {
  description = "The number of EC2 instances to launch"
  type        = number
  default     = 2 # Change this depending on how many instances you need
}

variable "ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
  default     = "ami-020cba7c55df1f615" # Default Ubuntu AMI, you can change this if needed
}

variable "instance_name_tag" {
  description = "The Name tag for the EC2 instance"
  type        = string
  default     = "raz_vpc-sub-ec2-instance"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "dev-vpc"
}

variable "subnet1_cidr" {
  description = "CIDR block for subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet1_name" {
  description = "Name tag for subnet 1"
  type        = string
  default     = "dev-subnet1"
}

variable "subnet2_cidr" {
  description = "CIDR block for subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet2_name" {
  description = "Name tag for subnet 2"
  type        = string
  default     = "dev-subnet2"
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
  default     = "Dev-IGW"
}

variable "route_table_name" {
  description = "Name tag for the Route Table"
  type        = string
  default     = "dev-route"
}
