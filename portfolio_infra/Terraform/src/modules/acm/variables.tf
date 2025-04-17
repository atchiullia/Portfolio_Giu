variable "domain_name" {
  description = "The domain name for the ACM certificate."
  type        = string  
}

variable "zone_id" {
  description = "The ID of the Route 53 hosted zone."
  type = string
}