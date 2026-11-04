variable "db_password" {
  description = "Password for the RDS database user"
  type        = string
  sensitive   = true
}