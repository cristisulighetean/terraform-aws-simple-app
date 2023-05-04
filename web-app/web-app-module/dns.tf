# Create a route53 dns zone for the given domain if create_dns_zone is true
resource "aws_route53_zone" "primary" {
  count = var.create_dns_zone ? 1 : 0
  name  = var.domain
}

# Fetch existing Route53 DNS zone for the given domain if create_dns_zone is false
data "aws_route53_zone" "primary" {
  count = var.create_dns_zone ? 0 : 1
  name  = var.domain
}

locals {
  # The dns_zone_id is set to the ID of the created DNS zone or the existing one, depending on the create_dns_zone variable
  dns_zone_id = var.create_dns_zone ? aws_route53_zone.primary[0].zone_id : data.aws_route53_zone.primary[0].zone_id
  # subdomain is set to an empty string if the environment_name is "production", otherwise, 
  # it is set to the environment name followed by a dot
  subdomain   = var.environment_name == "production" ? "" : "${var.environment_name}."
}

# Create an "A" record in the DNS zone for the specified subdomain and domain
resource "aws_route53_record" "root" {
  zone_id = local.dns_zone_id
  name    = "${local.subdomain}${var.domain}"
  # Record type is "A", which maps the domain name to an IPv4 address
  type    = "A"

  # Alias configuration for the "A" record
  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}