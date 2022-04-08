/* security groups*/
resource "aws_security_group" "RemoteAccess" {
  name               = "RemoteAccess"
  description        = "Allow http web sites"
  vpc_id             = "${aws_vpc.rdt_vpc.id}"
  ingress {
    description      = "allow http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  ingress {
    description      = "allow https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Project          = "${var.aws_project_name}"
    Name             = "RemoteAccess"
    Terraform        = true

  }
}

resource "aws_security_group_rule" "sgr_remote_ssh" {
  description       = "Allow remote SSH access"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks      = "${var.remote_ipaddress}"
 security_group_id = "${aws_security_group.remote_ssh.id}"
}

resource "aws_security_group" "open_ssh" {
  # Security group used for private instances to allow ssh access
  name               = "all_ssh"
  description        = "Allow ssh from/to anywhere"
  vpc_id             = "${aws_vpc.rdt_vpc.id}"

  ingress {
    description      = "allow http"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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
    "Name"           = "sg-all_ssh"   # FIXME: Replace hard code Tag Name
    "Terraform"      = true
  }
}

resource "aws_security_group" "remote_ssh" {
  name               = "RemoteSSH"
  description        = "Allow http web sites"
  vpc_id             = "${aws_vpc.rdt_vpc.id}"

  tags = {
    "Project"        = "${var.aws_project_name}"
    "Name"           = "RemoteSSH"   # FIXME: Replace hard code Tag Name
    "Terraform"      = true
  }

}
