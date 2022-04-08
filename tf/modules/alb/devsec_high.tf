variable "highArea" {
    type        = number
    default     = 0
    description = ""
}

resource "aws_alb_target_group" "high" {
  name                          = "DevSecOpsHigh"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = "${var.rdt_vcp.id}"
  load_balancing_algorithm_type = "round_robin"
  deregistration_delay          = 60
  stickiness {
    enabled = false
    type    = "lb_cookie"
    cookie_duration = 60
  }
  health_check {
    path = "/login"
    port = 80
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener_rule" "high" {

  listener_arn = aws_alb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.high.arn
  }

  condition {
    host_header {
      values = ["myprivate2.private"]
    }
  }
}

resource "aws_launch_configuration" "high" {
  name_prefix                 = "${var.private_ec2_name}"
  image_id                    = "${var.gitlab_ami_base.id}"
  instance_type               = "${var.ec2_type}"
  key_name                    = "${var.key_name.id}"
  depends_on                  = [var.gitlab_ami_base]
  # security_groups             = ["${aws_security_group.high.id}", "${var.security_groups}"]
  security_groups             = "${var.security_groups}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "high" {
  name_prefix          = "DevSecOpsHigh"
  launch_configuration = "${aws_launch_configuration.high.id}"
  min_size             = "1"
  max_size             = "1"
  desired_capacity     = "1"
  target_group_arns    = ["${aws_alb_target_group.high.arn}"]
  vpc_zone_identifier  = ["${var.subnet_private[var.highArea].id}"]
  health_check_type    = "EC2"
  depends_on           = [var.gitlab_ami_base]

  tag  {
      key          = "Name"
      value       = "launchInstance-high"
      propagate_at_launch = true
  }
  tag  {
      key          = "Project"
      value       = "${var.aws_project_name}"
      propagate_at_launch = true
  }
}

resource "aws_security_group" "high" {
  name               = "DevSecOpsHigh"
  description        = "Allow Access only devsecops from high area"
  vpc_id             = "${var.rdt_vcp.id}"
  ingress {
    description      = "allow ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.subnet_public[var.highArea].cidr_block}"]
    }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Project"        = "${var.aws_project_name}"
    "Name"           = "DevSecOpsHigh"   # FIXME: Replace hard code Tag Name
    "Terraform"      = true
  }
}

