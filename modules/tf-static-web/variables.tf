####################################################
# Bucket Name Variable
# - Defines the S3 bucket name to create
####################################################
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

####################################################
# IAM Policy Name Variable
# - Defines name of the IAM policy for bucket access
####################################################
variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  default     = "read-only-policy"
}
