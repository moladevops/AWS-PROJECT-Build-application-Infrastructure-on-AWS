
# create SNS topic
resource "aws_sns_topic" "utc-auto-scaling-topic" {
  name = "utc-auto-scaling-topic"
}

# create SNS subscription
resource "aws_sns_topic_subscription" "utcappserver_subscription" {
  topic_arn = aws_sns_topic.utc-auto-scaling-topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# send auto scaling notifications to the SNS topic
resource "aws_autoscaling_notification" "utc_asg_notifications" {
  group_names = [aws_autoscaling_group.utcappserver_asg.name]
  topic_arn   = aws_sns_topic.utc-auto-scaling-topic.arn
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
}