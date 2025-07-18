####################################################
# AWS Provider Configuration
# - Sets AWS region for this module
####################################################
provider "aws" {
  region = "us-east-1"
}

####################################################
# S3 Bucket Resource
# - Creates S3 bucket for hosting static website
# - Enables force destroy for cleanup
####################################################
resource "aws_s3_bucket" "my_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

####################################################
# S3 Bucket Public Access Block
# - Controls public access settings for bucket
####################################################
resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

####################################################
# S3 Bucket Website Configuration
# - Enables static website hosting on the bucket
# - Defines index and error documents
####################################################
resource "aws_s3_bucket_website_configuration" "my_website" {
  bucket = aws_s3_bucket.my_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

####################################################
# S3 Bucket Policy
# - Grants public read access to bucket objects
# - Depends on public access block resource
####################################################
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.my_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.my_bucket_public_access_block]
}

####################################################
# Static Website Files Upload
# - Uploads index.html, error.html, CSS, and JS files
####################################################
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "error.html"
  source       = "${path.module}/error.html"
  content_type = "text/html"
}

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "styles.css"
  source       = "${path.module}/styles.css"
  content_type = "text/css"
}

resource "aws_s3_object" "js" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "script.js"
  source       = "${path.module}/script.js"
  content_type = "application/javascript"
}
