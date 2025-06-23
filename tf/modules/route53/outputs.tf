
output "hosted_zone_arn" {
  description = "ARN of the created Route53 hosted zone"
  value       = aws_route53_zone.region.arn
}

output "hosted_zone_id" {
  description = "ID of the created Route53 hosted zone"
  value       = aws_route53_zone.region.zone_id
}

output "hosted_zone_name" {
  description = "Name of the created Route53 hosted zone"
  value       = aws_route53_zone.region.name
}

output "aws_acm_certificate_arn" {
  description = "ARN of the ACM certificate for the subdomain"
  value       = aws_acm_certificate.cert.arn
}
