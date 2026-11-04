

# create EFS file system
resource "aws_efs_file_system" "efs" {
  creation_token = "utc-efs"
  encrypted      = true
  tags = {
    Name = "utc-efs"
    env  = "dev"
    team = "config management"
  }
}
resource "aws_efs_mount_target" "efs_mount_target_1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.subnet_private_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "efs_mount_target_2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.subnet_private_2.id
  security_groups = [aws_security_group.efs_sg.id]
}
