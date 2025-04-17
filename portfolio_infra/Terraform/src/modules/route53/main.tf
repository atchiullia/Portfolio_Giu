# This module creates a Route 53 hosted zone for the specified domain name
resource "aws_route53_zone" "primary" {
  name = var.domain_name
  comment = "Managed by Terraform"
  force_destroy = true
  tags = {
    Name        = var.domain_name
    Environment = var.environment
  }
}


