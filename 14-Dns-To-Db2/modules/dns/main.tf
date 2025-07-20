# ACM Certificate
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.0.0"

  domain_name = var.domain_name
  zone_id = data.aws_route53_zone.hosted_zone.id

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  tags = var.common_tags
  
  validation_method = "DNS"
  wait_for_validation = true
}

# Route53 Records
resource "aws_route53_record" "alb_app_dns_record" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name = var.domain_name
  type = "A"
  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}


