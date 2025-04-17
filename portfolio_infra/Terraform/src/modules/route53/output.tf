# This output returns the ID of the Route 53 hosted zone created by the module
output "zone_id" {
  value = aws_route53_zone.primary.zone_id
}