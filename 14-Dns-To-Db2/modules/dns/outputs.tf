output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value = module.acm.acm_certificate_arn
}

output "route53_hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value = data.aws_route53_zone.hosted_zone.id
}

output "alb_dns_record_name" {
  description = "ALB DNS record name"
  value = aws_route53_record.alb_app_dns_record.name
} 