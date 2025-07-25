# -- ALB Monitoring --
resource "aws_cloudwatch_metric_alarm" "alb_4xx_error_alarm" {
  alarm_name          = "${var.name_prefix}-alb-4xx-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 100
  alarm_description   = "This metric monitors the number of 4xx errors for the ALB"
  alarm_actions       = [aws_sns_topic.spring_boot_app_notifications.arn]

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "spring_boot_app_4xx_error_alarm" {
  alarm_name          = "${var.name_prefix}-spring-boot-app-4xx-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 100
  alarm_description   = "This metric monitors the number of 4xx errors for the Spring Boot App"
  alarm_actions       = [aws_sns_topic.spring_boot_app_notifications.arn]

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.spring_boot_app_target_group_arn
  }
}

# -----Alarms for Spring Boot Canaries Heartbeat ------#
resource "aws_cloudwatch_metric_alarm" "spring_boot_heartbeat_success_rate" {
  alarm_name          = "${var.name_prefix}-spring-boot-heartbeat-success-rate-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  metric_name         = "SuccessPercent"
  namespace           = "CloudWatchSynthetics"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric monitors the success rate of the Spring Boot Heartbeat"
  alarm_actions       = [aws_sns_topic.spring_boot_app_notifications.arn]
  ok_actions          = [aws_sns_topic.spring_boot_app_notifications.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    CanaryName = aws_synthetics_canary.spring-boot-app-heartbeat.id
  }

  tags = var.common_tags

}

#Canary failed Alarm
resource "aws_cloudwatch_metric_alarm" "spring_boot_heartbeat_canary_alarm" {
  alarm_name          = "${var.name_prefix}-spring-boot-heartbeat-canary-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Failed"
  namespace           = "CloudWatchSynthetics"
  period              = 300
  statistic           = "Sum"
  threshold           = 2
  alarm_description   = "Spring Boot heartbeat canary has multiple  failed runs"
  alarm_actions       = [aws_sns_topic.spring_boot_app_notifications.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    CanaryName = aws_synthetics_canary.spring-boot-app-heartbeat.id
  }

  tags = var.common_tags

}



