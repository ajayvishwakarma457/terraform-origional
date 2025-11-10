# ==========================================================
# Application Load Balancer + Auto Scaling Module
# ==========================================================

# ----------------------------------------------------------
# Load Balancer + Target Group
# ----------------------------------------------------------

resource "aws_lb" "app_lb" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]        # 👈 Comes from security-group module
  subnets            = var.public_subnet_ids

  tags = merge(var.common_tags, { Name = "${var.project_name}-alb" })
}

resource "aws_lb_target_group" "app_tg" {
  name        = "${var.project_name}-tg"
  vpc_id      = var.vpc_id
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = merge(var.common_tags, { Name = "${var.project_name}-tg" })
}

# HTTP Listener → Redirect to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener (with ACM certificate)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# ----------------------------------------------------------
# Launch Template + Auto Scaling Group
# ----------------------------------------------------------

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    security_groups             = [var.app_sg_id]    # 👈 From security-group module
    associate_public_ip_address = false
  }

  user_data = base64encode(var.user_data != "" ? var.user_data : <<-EOT
    #!/bin/bash
    yum -y update
    yum -y install nginx
    systemctl enable nginx
    echo "Welcome to ${var.project_name} AutoScaling Instance - $(hostname)" > /usr/share/nginx/html/index.html
    systemctl start nginx
  EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, { Name = "${var.project_name}-instance" })
  }

  tags = merge(var.common_tags, { Name = "${var.project_name}-lt" })
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project_name}-asg"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
