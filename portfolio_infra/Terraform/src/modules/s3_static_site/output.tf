output "website_endpoint" {
  value = aws_s3_bucket.aws_bucket_website_configuration.website.website_endpoint
  description = "The endpoint of the S3 bucket website."
}