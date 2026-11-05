
# create an AMI from any EC2 instance
resource "aws_ami_from_instance" "utcappserver" {
  name                    = "utcappserver"
  source_instance_id      = aws_instance.ec2_instance1.id
  snapshot_without_reboot = true

  tags = {
    Name = "utcappserver"
    env  = "dev"
    team = "config management"
  }
}