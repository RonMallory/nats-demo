# Ensure the AWS provider uses our region and default tags
provider "aws" {
  region = var.region


  default_tags {
    tags = local.default_tags
  }
}

data "aws_availability_zones" "available" {}

locals {
  name_prefix = "${var.env}-${var.stack}-${var.region}"

  region = var.region
  default_tags = merge(
    {
      Environment = var.env
      Stack       = var.stack
      Region      = var.region
      App         = var.app
    },
    var.tags
  )
}

# Fetch the root hosted zone i.e. dev.example.com
data "aws_route53_zone" "this" {
  name         = var.env_hosted_zone_name
  private_zone = false
}

# Create a subdomain hosted zone i.e. <region>.<env>.example.com
resource "aws_route53_zone" "region" {
  name = "${var.region}.${data.aws_route53_zone.this.name}"
  tags = local.default_tags
}

# Delegate the subdomain via NS records in the parent zone
resource "aws_route53_record" "region_ns" {
  name    = var.subdomain_name
  zone_id = data.aws_route53_zone.this.zone_id
  type    = "NS"
  ttl     = 30
  records = aws_route53_zone.region.name_servers
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${aws_route53_zone.region.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = aws_route53_zone.region.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
