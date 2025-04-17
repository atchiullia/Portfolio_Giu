resource "aws_s3_bucket" "website" {
  bucket = var.domain_name
  tags = {
    Name = "Static Site Hosting Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "controls" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "unblock_policy" {
  bucket = aws_s3_bucket.website.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [ aws_s3_bucket_ownership_controls.controls ]
  bucket = aws_s3_bucket.website.id
  acl = "public-read"
}

resource "aws_bucket_website_configuration" "website"{
  bucket = aws_s3_bucket.website.id
  index_document { suffix = "index.html" }
  error_document { key = "404.html" }
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website.id
  policy = jsondecode({
    Version = "2012-10-17",
    Statement = [{
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
      }]
  })
  depends_on = [ aws_s3_bucket_public_access_block.unblock_policy ]
}