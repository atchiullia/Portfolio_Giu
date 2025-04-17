# This module creates a Route 53 hosted zone for the specified domain name
resource "aws_route53_zone" "primary" {
  name = var.domain_name
  comment = "Managed by Terraform"
  tags = {
    Name        = var.domain_name
  }
}


