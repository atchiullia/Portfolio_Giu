# Portfolio Infrastructure with Terraform

This directory contains the Terraform configuration for deploying your portfolio website infrastructure on AWS.

## Latest Updates (2024)

This configuration has been updated to use the latest Terraform best practices:

### Security Improvements
- **S3 Bucket Ownership Controls**: Required for new S3 buckets
- **Public Access Block Configuration**: Explicit control over public access
- **Modern ACL Configuration**: Using separate `aws_s3_bucket_acl` resource
- **TLS 1.3 Support**: Added TLS 1.3 to CloudFront origin SSL protocols

### Deprecation Fixes
- **Removed deprecated `acl` attribute** from S3 bucket resource
- **Replaced deprecated `forwarded_values`** with modern cache policies
- **Updated CloudFront configuration** to use managed policies

### Performance & UX Improvements
- **SPA Routing Support**: Custom error response for single-page applications
- **Modern Cache Policies**: Using AWS managed caching policies
- **CORS Support**: Proper origin request policy for S3

## Infrastructure Components

### 1. S3 Bucket (`aws_s3_bucket.portfolio`)
- Static website hosting
- Public read access for web content
- Proper ownership controls and public access configuration

### 2. CloudFront Distribution (`aws_cloudfront_distribution.cdn`)
- Global CDN for fast content delivery
- HTTPS enforcement with custom domain support
- Modern caching policies for optimal performance

### 3. SSL Certificate (`aws_acm_certificate.cert`)
- Free SSL certificate from AWS Certificate Manager
- DNS validation for security
- Supports both apex domain and www subdomain

### 4. Route 53 (`aws_route53_zone.optional_zone`)
- Optional DNS hosting (can be removed if using external DNS)
- Automatic DNS validation for SSL certificate

## Prerequisites

1. **AWS CLI configured** with appropriate credentials
2. **Terraform >= 1.0** installed
3. **Domain name** registered (can be external to AWS)

## Deployment Steps

### 1. Initialize Terraform
```bash
cd portfolio_infra/Terraform/src
terraform init
```

### 2. Plan the Deployment
```bash
terraform plan -var="domain_name=yourdomain.com"
```

### 3. Apply the Configuration
```bash
terraform apply -var="domain_name=yourdomain.com"
```

### 4. Upload Your Website Files
```bash
# Sync your portfolio files to S3
aws s3 sync ../../portfolio/ s3://yourdomain.com --delete
```

## Security Features

- **S3 Bucket Policy**: Only allows public read access to objects
- **CloudFront Security**: HTTPS enforcement and modern TLS versions
- **Public Access Controls**: Explicit configuration of S3 public access
- **Origin Protection**: S3 bucket not directly accessible via custom domain

## Outputs

After successful deployment, you'll get:

- **Website Endpoint**: S3 static hosting URL
- **CloudFront Domain**: CDN distribution domain
- **Certificate ARN**: SSL certificate reference
- **Bucket Information**: S3 bucket details

## What's New in This Version

### S3 Bucket Configuration
```hcl
# OLD (Deprecated)
resource "aws_s3_bucket" "portfolio" {
  acl = "public-read"  # Deprecated
  website { ... }      # Deprecated
}

# NEW (Current Best Practice)
resource "aws_s3_bucket" "portfolio" { ... }
resource "aws_s3_bucket_ownership_controls" "portfolio" { ... }
resource "aws_s3_bucket_acl" "portfolio" { ... }
resource "aws_s3_bucket_website_configuration" "portfolio" { ... }
```

### CloudFront Configuration
```hcl
# OLD (Deprecated)
default_cache_behavior {
  forwarded_values { ... }  # Deprecated
}

# NEW (Current Best Practice)
default_cache_behavior {
  cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a9be6fceb"
  origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
}
```

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy -var="domain_name=yourdomain.com"
```

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS S3 Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/best-practices.html)
- [CloudFront Best Practices](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/best-practices.html)

## Important Notes

1. **Domain Name**: Must match your actual domain name
2. **Region**: Must be `us-east-1` for CloudFront + ACM compatibility
3. **Costs**: S3 storage, CloudFront data transfer, and Route 53 hosting fees apply
4. **SSL Validation**: DNS validation required for SSL certificate

## Future Updates

This configuration is designed to be future-proof and will be updated as new Terraform features and AWS services become available.
