variable "domain_name" {
  type = string
  description = "The domain name for the CloudFront distribution."  
}

variable "website_endpoint" {
  type = string
  description = "The endpoint of the S3 bucket website."
}

variable "certificate_arn" {
  type = string
  description = "The ARN of the ACM certificate."
}