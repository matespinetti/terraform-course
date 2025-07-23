output "spring_boot_app_asg_notifications_topic_arn" {
  description = "ARN of the Spring Boot App Auto Scaling Group Notifications Topic"
  value = aws_sns_topic.spring_boot_app_asg_notifications.arn
}

output "spring_boot_app_asg_notifications_topic_name" {
  description = "Name of the Spring Boot App Auto Scaling Group Notifications Topic"
  value = aws_sns_topic.spring_boot_app_asg_notifications.name
}