provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_bucket_s" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.tf_bucket_s.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "s3_tf" {
  name        = "tf_bucket_s3_policy"
  description = "IAM Policy for S3 Read Access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:Get*",
          "s3:List*"
        ],
        Resource = "*"
      }
    ]
  })
}

output "bucket_name" {
  value       = aws_s3_bucket.tf_bucket_s.bucket
  description = "The name of the S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.tf_bucket_s.arn
  description = "The ARN of the S3 bucket"
}

output "bucket_url" {
  value       = "https://${aws_s3_bucket.tf_bucket_s.bucket}.s3.amazonaws.com"
  description = "Web address of the S3 bucket"
}
