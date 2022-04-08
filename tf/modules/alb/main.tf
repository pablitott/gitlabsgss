# source: https://hiveit.co.uk/techshop/terraform-aws-vpc-example/04-create-the-application-load-balancer/
# source: https://github.com/anandg1/Terraform-AWS-ApplicationLoadBalancer
resource "aws_security_group" "alb" {
  name        = "gitlab_alb_security_group"
  description = "Gitlab Load Balancer Security Group"
  vpc_id      = "${var.rdt_vcp.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Project        = "${var.aws_project_name}"
    Name           = "sg-all"
    Terraform      = true
  }
}

resource "aws_alb" "alb" {
  name            = "Gitlab-ALB"
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = var.subnet_public.*.id
  tags = {
    Project        = "${var.aws_project_name}"
    Name           = "GitLab ALB"
    Terraform      = true
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = " Site Not Found"
      status_code  = "200"
   }
}
  #  default_action {
  #   target_group_arn = "${aws_alb_target_group.low.arn}"
  #   type             = "forward"
  # }
  depends_on = [  aws_alb.alb ]

}

# I do not have certificate at this time
# resource "aws_alb_listener" "https" {
#   load_balancer_arn = "${aws_alb.alb.arn}"
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "${var.certificate_arn}"
#   default_action {
#     target_group_arn = "${aws_alb_target_group.low.arn}"
#     type             = "forward"
#   }
# depends_on = [  aws_alb.alb ]

# }
