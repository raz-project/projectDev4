####################################################
# Bucket Name Output
# - Outputs the created S3 bucket name
####################################################
output "bucket_name" {
  value       = aws_s3_bucket.my_bucket.bucket
  description = "The name of the created S3 bucket"
}

####################################################
# Bucket ARN Output
# - Outputs the ARN of the created S3 bucket
####################################################
output "bucket_arn" {
  value       = aws_s3_bucket.my_bucket.arn
  description = "ARN of the created S3 bucket"
}

####################################################
# Website Endpoint Output
# - Outputs the public S3 website endpoint URL
####################################################
output "bucket_website_endpoint" {
  value       = aws_s3_bucket_website_configuration.my_website.website_endpoint
  description = "Public S3 website endpoint"
}

####################################################
# Bucket Region Output
# - Outputs the AWS region where the bucket is created
####################################################
output "bucket_region" {
  value       = aws_s3_bucket.my_bucket.region
  description = "Region of the bucket"
}

####################################################
# Index Object URL Output
# - Outputs direct URL to the index.html file
####################################################
output "index_object_url" {
  value       = "https://${aws_s3_bucket.my_bucket.bucket}.s3.amazonaws.com/index.html"
  description = "Direct URL to index.html"
}

####################################################
# Error Object URL Output
# - Outputs direct URL to the error.html file
####################################################
output "error_object_url" {
  value       = "https://${aws_s3_bucket.my_bucket.bucket}.s3.amazonaws.com/error.html"
  description = "Direct URL to error.html"
}
