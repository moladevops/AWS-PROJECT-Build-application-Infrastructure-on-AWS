



variable "db_password" {
  description = "Password for the RDS database user"
  type        = string
  sensitive   = true
}

variable "notification_email" {
  description = "Email address to receive SNS notifications"
  type        = string
}
