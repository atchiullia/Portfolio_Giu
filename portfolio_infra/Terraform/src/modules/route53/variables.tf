# This variable is used to specify the domain name for the Route 53 hosted zone.
variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone."
  type        = string
}

# This variable is used to specify the environment for the Route 53 hosted zone.
variable "environment" {
  description = "The environment for the Route 53 hosted zone."
  type        = string
}