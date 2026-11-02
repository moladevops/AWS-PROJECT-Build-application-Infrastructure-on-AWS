
# create a load balancer
resource "aws_lb" "utc-lb" {
  name               = "utc-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet_public_1.id, aws_subnet.subnet_public_2.id]

  enable_deletion_protection = false

  tags = {
    env  = "dev"
    team = "config management"
  }
}

# create a target group
resource "aws_lb_target_group" "utc-target-group" {
  name             = "utc-target-group"
  port             = 80
  protocol         = "HTTP"
  vpc_id           = aws_vpc.utc-vpc.id
  target_type      = "instance"
  protocol_version = "HTTP1"

  health_check {
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    env  = "dev"
    team = "config management"
  }
}

# create a listener for the load balancer
resource "aws_lb_listener" "utc-listener" {
  load_balancer_arn = aws_lb.utc-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.utc-target-group.arn
  }

  tags = {
    env  = "dev"
    team = "config management"
  }
}

# register the EC2 instances with the target group

resource "aws_lb_target_group_attachment" "utc-target-group-attachment" {
  target_group_arn = aws_lb_target_group.utc-target-group.arn
  target_id        = aws_instance.ec2_instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "utc-target-group-attachment-2" {
  target_group_arn = aws_lb_target_group.utc-target-group.arn
  target_id        = aws_instance.ec2_instance2.id
  port             = 80
}
