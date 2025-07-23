# -- SNS Topic for Spring Boot App ASG Notifications --
resource "aws_sns_topic" "spring_boot_app_notifications" {
  name = "${var.name_prefix}-spring-boot-app-notifications"
}

resource "aws_sns_topic_subscription" "spring_boot_app_asg_notifications_email" {
  topic_arn = aws_sns_topic.spring_boot_app_notifications.arn
  protocol = "email"
  endpoint = var.email_address
}

resource "aws_autoscaling_notification" "spring_boot_app_asg_notifications" {
  group_names = [var.spring_boot_app_asg_name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.spring_boot_app_notifications.arn
}

# -- ALB Monitoring --
resource "aws_cloudwatch_metric_alarm" "alb_4xx_error_alarm" {
  alarm_name = "${var.name_prefix}-alb-4xx-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 3
  datapoints_to_alarm = 2
  metric_name = "HTTPCode_Target_4XX_Count"
  namespace = "AWS/ApplicationELB"
  period = 300
  statistic = "Sum"
  threshold = 100
  alarm_description = "This metric monitors the number of 4xx errors for the ALB"
  alarm_actions = [aws_sns_topic.spring_boot_app_notifications.arn]
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

}


resource "aws_cloudwatch_metric_alarm" "spring_boot_app_4xx_error_alarm" {
  alarm_name = "${var.name_prefix}-spring-boot-app-4xx-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 3
  datapoints_to_alarm = 2
  metric_name = "HTTPCode_Target_4XX_Count"
  namespace = "AWS/ApplicationELB"
  period = 300
  statistic = "Sum"
  threshold = 100
  alarm_description = "This metric monitors the number of 4xx errors for the Spring Boot App"
  alarm_actions = [aws_sns_topic.spring_boot_app_notifications.arn]
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup = var.spring_boot_app_target_group_arn
  }
  
}



# -- CIS Alarms --
module "cis_log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "5.7.1"

  name = "${var.name_prefix}-cis-log-group"
  retention_in_days = 30
  


  
}

module "all_cis_alarms" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/cis-alarms"
  version = "5.7.1"
  disabled_controls = ["DisableOrDeleteCMK", "VPCChanges"]
  log_group_name = module.cis_log_group.name
  alarm_actions = [aws_sns_topic.spring_boot_app_notifications.arn]
  tags = var.common_tags
  
}