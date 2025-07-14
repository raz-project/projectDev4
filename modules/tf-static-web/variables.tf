variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  default     = "read-onlys3-policy" # Default policy name (can be overridden)
}

