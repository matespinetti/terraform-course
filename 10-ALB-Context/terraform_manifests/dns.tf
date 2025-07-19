resource "aws_route53_record" "alb_dns_record" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name = "apps.${var.domain_name}"
  type = "A"
  alias {
    name = module.alb.dns_name
    zone_id = module.alb.zone_id 
    evaluate_target_health = true
  }

}