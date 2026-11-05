# create launch template
resource "aws_launch_template" "utcappserver_lt" {
  name                   = "utcappserver-lt"
  image_id               = aws_ami_from_instance.utcappserver.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.utc_key.key_name
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.utc_ec2_profile.name
  }

  # Apache, EFS and cron are already in the AMI: only refresh the page with this server's name
  user_data = base64encode(<<-EOF
#!/bin/bash
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "utcappserver-asg"
      env  = "dev"
      team = "config management"
    }
  }

  tags = {
    env  = "dev"
    team = "config management"
  }
}

# create auto scaling group
resource "aws_autoscaling_group" "utcappserver_asg" {
  name                      = "utcappserver-asg"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.subnet_private_1.id, aws_subnet.subnet_private_2.id]
  target_group_arns         = [aws_lb_target_group.utc-target-group.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.utcappserver_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "env"
    value               = "dev"
    propagate_at_launch = true
  }

  tag {
    key                 = "team"
    value               = "config management"
    propagate_at_launch = true
  }
}


# scale on CPU: keep average around 80%
resource "aws_autoscaling_policy" "utc-cpu-target-tracking" {
  name                      = "utc-cpu-target-tracking"
  autoscaling_group_name    = aws_autoscaling_group.utcappserver_asg.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80
  }
}