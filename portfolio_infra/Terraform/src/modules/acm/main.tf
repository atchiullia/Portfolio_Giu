provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  provider = aws.us_east_1
  domain_name = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method = "DNS"

  lifecycle{
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation"{
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      type = dvo.resource_record_type
      record = dvo.resource_record_value 
    }
  }

  zone_id = var.zone_id
  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.us_east_1
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdns]

  depends_on = [aws_route53_record.cert_validation]
}
