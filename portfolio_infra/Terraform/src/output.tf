# Outputs
output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.portfolio.website_endpoint
  description = "The endpoint of the S3 bucket website."
}

output "bucket_name" {
  value       = aws_s3_bucket.portfolio.bucket
  description = "The name of the S3 bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.portfolio.arn
  description = "The ARN of the S3 bucket."
}

output "certificate_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "The ARN of the ACM certificate."
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.cdn.id
  description = "The ID of the CloudFront distribution."
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "The domain name of the CloudFront distribution."
}

output "zone_id" {
  value       = aws_route53_zone.optional_zone.zone_id
  description = "The ID of the Route 53 hosted zone."
}
