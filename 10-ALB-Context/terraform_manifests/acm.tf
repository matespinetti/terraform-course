module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.0.0"

  domain_name = var.domain_name
  zone_id = data.aws_route53_zone.hosted_zone.id

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  tags = local.common_tags
  validation_method = "DNS"

  wait_for_validation = true
}