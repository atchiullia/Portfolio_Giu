# Use AWS provider in the N. Virginia region (required for CloudFront + ACM)
provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket to host your static website
resource "aws_s3_bucket" "portfolio" {
  bucket = var.domain_name           # Bucket name must match your domain

  tags = {
    Name = "Static Site Hosting Bucket"
  }
}

# Configure S3 bucket ownership controls (required for new buckets)
resource "aws_s3_bucket_ownership_controls" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure S3 bucket ACL (using the new approach)
resource "aws_s3_bucket_acl" "portfolio" {
  depends_on = [aws_s3_bucket_ownership_controls.portfolio]

  bucket = aws_s3_bucket.portfolio.id
  acl    = "public-read"
}

# Configure S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure S3 bucket website hosting
resource "aws_s3_bucket_website_configuration" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# Give public read access to all objects in the S3 bucket
resource "aws_s3_bucket_policy" "public_read" {
  depends_on = [aws_s3_bucket_public_access_block.portfolio]

  bucket = aws_s3_bucket.portfolio.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",               # Allow anyone to access
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.portfolio.arn}/*"
    }]
  })
}

# Request a public SSL certificate from AWS Certificate Manager (ACM)
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name                  # e.g. yourcoolportfolio.com
  validation_method         = "DNS"                            # We'll validate it using DNS records
  subject_alternative_names = ["www.${var.domain_name}"]       # Include www version of your site

  lifecycle {
    create_before_destroy = true
  }
}

# (Optional) Create a Route 53 hosted zone if you move DNS to AWS
# You can remove this block if you're staying with Squarespace DNS
resource "aws_route53_zone" "optional_zone" {
  name = var.domain_name
}

# Add DNS validation records for ACM (used only if Route 53 is used)
resource "aws_route53_record" "cert_records" {
  count = length(aws_acm_certificate.cert.domain_validation_options)

  zone_id = aws_route53_zone.optional_zone.zone_id
  name    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_type
  records = [aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_value]
  ttl     = 60
}

# Wait until ACM certificate is validated using the DNS records
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_records : record.fqdn]
}

# Create the CloudFront CDN to serve your website globally with HTTPS
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.portfolio.website_endpoint  # The S3 static hosting endpoint
    origin_id   = "S3-${aws_s3_bucket.portfolio.id}"

    custom_origin_config {
      origin_protocol_policy = "http-only"         # S3 only supports HTTP, not HTTPS directly
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.3"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"              # Show index.html by default

  aliases = [var.domain_name, "www.${var.domain_name}"]  # Enable custom domain support

  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.portfolio.id}"
    viewer_protocol_policy = "redirect-to-https"         # Always redirect to HTTPS

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    # Use modern cache policy instead of deprecated forwarded_values
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a9be6fceb"  # Managed-CachingOptimized

    # Use modern origin request policy
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"  # Managed-CORS-S3Origin
  }

  # Add custom error response for SPA routing
  custom_error_response {
    error_code         = 404
    response_code      = "200"
    response_page_path = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn     # Use the validated cert
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"  # No geo blocking
    }
  }

  tags = {
    Name = "My Portfolio CloudFront"
  }
}
