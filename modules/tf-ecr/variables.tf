#################################################
#                   VARIABLES                   #
#                   for EC2                     #
#################################################

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "project_dev"
}

variable "instance_count" {
  description = "The number of EC2 instances to launch"
  type        = number
  default     = 1
}

variable "ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "The instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "instance_name_tag" {
  description = "The Name tag for the EC2 instance"
  type        = string
  default     = "raz_ec2-instance"
}
