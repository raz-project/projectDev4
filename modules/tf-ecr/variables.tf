

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "project_dev" # Default value if not specified
}

variable "instance_count" {
  description = "The number of EC2 instances to launch"
  type        = number
  default     = 1 # Default to 1 instance
}

variable "ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
  default     = "ami-020cba7c55df1f615" # Default Ubuntu AMI, you can change this if needed
}

variable "instance_name_tag" {
  description = "The Name tag for the EC2 instance"
  type        = string
  default     = "raz_ec2-instance" # Default name for the instance
}
