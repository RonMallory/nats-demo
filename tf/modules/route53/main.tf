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

data "aws_route53_zone" "this" {
  name         = "${var.env}.${var.env_hosted_zone_name}"
  private_zone = false
}

resource "aws_route53_zone" "env-zone" {
  count = var.subdomain_name != "" ? 1 : 0
  name  = "${var.subdomain_name}.${data.aws_route53_zone.this.name}"
  tags  = local.default_tags
}

resource "aws_route53_record" "subdomain-ns" {
  count   = var.subdomain_name != "" ? 1 : 0
  name    = var.subdomain_name
  zone_id = data.aws_route53_zone.this.zone_id
  type    = "NS"
  ttl     = 30
  records = aws_route53_zone.env-zone[0].name_servers
}
