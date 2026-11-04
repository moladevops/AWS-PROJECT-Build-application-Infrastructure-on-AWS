# find latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# find latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# create bastion host
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.utc_key.key_name
  subnet_id                   = aws_subnet.subnet_public_1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  # how Terraform connects to the bastion
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.utc_key.private_key_pem
    host        = self.public_ip
  }

  # copy the key to the bastion
  provisioner "file" {
    source      = local_file.utc_key.filename
    destination = "/home/ec2-user/utc-key.pem"
  }

  # change key permission to 400
  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/utc-key.pem"
    ]
  }

  tags = {
    Name = "bastion-host"
    env  = "dev"
    team = "config management"
  }
}


# create ec2 instance

resource "aws_instance" "ec2_instance1" {

  iam_instance_profile        = aws_iam_instance_profile.utc_ec2_profile.name
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.utc_key.key_name
  subnet_id                   = aws_subnet.subnet_private_1.id
  vpc_security_group_ids      = [aws_security_group.app_server_sg.id]
  associate_public_ip_address = false
  user_data                   = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
EOF

  tags = {
    Name = "appserver-1a"
    env  = "dev"
    team = "config management"

  }
}

resource "aws_instance" "ec2_instance2" {

  iam_instance_profile        = aws_iam_instance_profile.utc_ec2_profile.name
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.utc_key.key_name
  subnet_id                   = aws_subnet.subnet_private_2.id
  vpc_security_group_ids      = [aws_security_group.app_server_sg.id]
  associate_public_ip_address = false
  user_data                   = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
EOF

  tags = {
    Name = "appserver-1b"
    env  = "dev"
    team = "config management"

  }
}
