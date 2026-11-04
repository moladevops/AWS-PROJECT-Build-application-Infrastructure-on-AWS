# create S3 bucket for httpd logs

resource "aws_s3_bucket" "utc_logs" {
  bucket        = "utc-httpd-logs-theodoremayi"
  force_destroy = true

  tags = {
    Name = "utc-httpd-logs"
    env  = "dev"
    team = "config management"
  }
}