output "bucket_name" {
  value       = aws_s3_bucket.my_bucket.bucket
  description = "The name of the created S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.my_bucket.arn
  description = "ARN of the created S3 bucket"
}

output "bucket_website_endpoint" {
  value       = aws_s3_bucket_website_configuration.my_website.website_endpoint
  description = "Public S3 website endpoint"
}

output "bucket_region" {
  value       = aws_s3_bucket.my_bucket.region
  description = "Region of the bucket"
}

output "index_object_url" {
  value       = "https://${aws_s3_bucket.my_bucket.bucket}.s3.amazonaws.com/index.html"
  description = "Direct URL to index.html"
}

output "error_object_url" {
  value       = "https://${aws_s3_bucket.my_bucket.bucket}.s3.amazonaws.com/error.html"
  description = "Direct URL to error.html"
}
