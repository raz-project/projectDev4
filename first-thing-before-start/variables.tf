####################################################
# Bucket Name Variable
# - Defines the S3 bucket name
####################################################
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "tf-state-s3-buc"
}
