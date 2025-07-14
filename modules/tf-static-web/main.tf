provider "aws" {
  region = "us-east-1"
}

# Define the S3 bucket resource
resource "aws_s3_bucket" "my_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

# Configure Block Public Access settings for the bucket
resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false # Allow public ACLs (Optional)
  block_public_policy     = false # Allow public policies
  ignore_public_acls      = false # Don't ignore public ACLs
  restrict_public_buckets = false # Don't restrict public buckets
}

# S3 Website Configuration (Enable Static Website Hosting)
resource "aws_s3_bucket_website_configuration" "my_website" {
  bucket = aws_s3_bucket.my_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Bucket Policy for Public Read
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
}

# Upload static content (index.html, error.html, styles.css, script.js)
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "error.html"
  source       = "./error.html"
  content_type = "text/html"
}

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "styles.css"
  source       = "./styles.css"
  content_type = "text/css"
}

resource "aws_s3_object" "js" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "script.js"
  source       = "./script.js"
  content_type = "application/javascript"
}


