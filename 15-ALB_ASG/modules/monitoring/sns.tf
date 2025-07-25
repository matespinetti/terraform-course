# -- SNS Topic for Spring Boot App ASG Notifications --
resource "aws_sns_topic" "spring_boot_app_notifications" {
  name = "${var.name_prefix}-spring-boot-app-notifications"
}

resource "aws_sns_topic_subscription" "spring_boot_app_asg_notifications_email" {
  topic_arn = aws_sns_topic.spring_boot_app_notifications.arn
  protocol  = "email"
  endpoint  = var.email_address
}
