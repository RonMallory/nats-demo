
output "hosted_zone_arn" {
  description = "ARN of the created Route53 hosted zone"
  value       = aws_route53_zone.region.arn
}
