# 1. IAM role: WHO can use it -> EC2 only
resource "aws_iam_role" "utc_ec2_s3_role" {
  name = "utc-ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "utc-ec2-s3-role"
    env  = "dev"
    team = "config management"
  }
}

# 2. Permissions: WHAT the role can do -> write to the logs bucket only
resource "aws_iam_role_policy" "utc_s3_logs_policy" {
  name = "utc-s3-logs-policy"
  role = aws_iam_role.utc_ec2_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.utc_logs.arn,
          "${aws_s3_bucket.utc_logs.arn}/*"
        ]
      }
    ]
  })
}

# 3. Instance profile: lets an EC2 instance carry the role
resource "aws_iam_instance_profile" "utc_ec2_profile" {
  name = "utc-ec2-profile"
  role = aws_iam_role.utc_ec2_s3_role.name

  tags = {
    env  = "dev"
    team = "config management"
  }
}