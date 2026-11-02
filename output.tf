output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "appserver_1a_private_ip" {
  value = aws_instance.ec2_instance1.private_ip
}

output "appserver_1b_private_ip" {
  value = aws_instance.ec2_instance2.private_ip
}