# -- CIS Monitoring --
module "cis_log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "5.7.1"

  name              = "${var.name_prefix}-cis-log-group"
  retention_in_days = 30
}

module "all_cis_alarms" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/cis-alarms"
  version = "5.7.1"

  disabled_controls = ["DisableOrDeleteCMK", "VPCChanges"]
  log_group_name    = module.cis_log_group.cloudwatch_log_group_name
  alarm_actions     = [aws_sns_topic.spring_boot_app_notifications.arn]
  tags              = var.common_tags
}
