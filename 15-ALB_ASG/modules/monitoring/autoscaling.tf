# -- ASG Notifications --
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
