################ Modules  #############################
/* networking  */
module "networking" {
  source = "./modules/networking"
  # region               = "us-east-1"
  aws_project_name      = "${var.aws_project_name}"
  vpc_cidr              = "${var.vpc_cidr}"
  # public_subnets_cidr   = "${var.public_subnets_cidr}"
  # private_subnets_cidr  = "${var.private_subnets_cidr}"
  subnet_bit            = "${var.subnet_bit}"
  availability_zones    = "${data.aws_availability_zones.available}"
  public_subnets_count  = "${var.public_subnets_count}"
  private_subnets_count = "${var.private_subnets_count}"
  # public_ec2_name       = "${var.public_ec2_name}"
}

################ private key #############################
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
    provisioner "local-exec" { # Create private ssh key .pem" on local computer!!
    command = "echo '${tls_private_key.ssh.private_key_pem}' > ${local.ssh_key_file_name}"
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "ssh_key_file" {
  filename              = pathexpand("${local.ssh_key_file_name}")
  file_permission       = "${local.inventory_file_permission}"
  directory_permission  = "${local.inventory_folder_permission}"
  content     = tls_private_key.ssh.private_key_pem
}

################     main resources    #############################
/* security groups*/
resource "aws_security_group" "RemoteAccess" {
  name               = "RemoteAccess"
  description        = "Allow http web sites"
  vpc_id             = "${module.networking.vpc_id}"
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

resource "aws_security_group_rule" "AllowAllTraffic" {
  type              = "egress"
  description      = "all traffic"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

 security_group_id = "${aws_security_group.remote_ssh.id}"
}

resource "aws_security_group" "open_ssh" {
  # Security group used for private instances to allow ssh access
  name               = "all_ssh"
  description        = "Allow ssh from/to anywhere"
  vpc_id             = "${module.networking.vpc_id}"

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
  vpc_id             = "${module.networking.vpc_id}"

  tags = {
    "Project"        = "${var.aws_project_name}"
    "Name"           = "RemoteSSH"   # FIXME: Replace hard code Tag Name
    "Terraform"      = true
  }

}

resource "aws_network_interface" "public" {

  count            = "${var.public_subnets_count}"
  subnet_id        = "${element(module.networking.public_subnet.*.id, count.index)}"

  security_groups  = [
    aws_security_group.remote_ssh.id,
    aws_security_group.RemoteAccess.id
    ]

  tags = {
    "Name"         = "Public NetWork Interface ${count.index + 1}"
    "Project"      = "${var.aws_project_name}"
    "Terraform"    = true
  }
}

resource "aws_network_interface" "private" {

  count            = "${var.private_subnets_count}"
  subnet_id        = "${element(module.networking.private_subnet.*.id, count.index)}"
  security_groups  = [ aws_security_group.open_ssh.id ]

  tags = {
    "Name"         = "Private NetWork Interface ${count.index + 1}"
    "Project"      = "${var.aws_project_name}"
    "Terraform"    = true
  }
}
/* EC2 Instances */
resource "aws_instance" "publichost" {
  # NOTE: Code for public hosts
  count               = "${var.private_subnets_count}"
  ami                 = data.aws_ami.Amazon_Linux2.image_id
  instance_type       = "${var.ec2_type}"
  tenancy             = "default"
  key_name            = aws_key_pair.generated_key.key_name
  hibernation         = false
  availability_zone   = "${element(data.aws_availability_zones.available.names.*, count.index)}"

  network_interface {
    network_interface_id = "${element(aws_network_interface.public.*.id, count.index)}"
    device_index         = 0
  }

  tags                = {
      "Name"          = "${var.public_ec2_name}${count.index + 1}"
      "Project"       = "${var.aws_project_name}"
      "HostName"      = "${var.ec2_hostname}${count.index + 1}.${var.ec2_gitlab_domain}"

  }
}

resource "aws_instance" "privatehost" {
  # NOTE: Code for private hosts
  count               = "${var.private_subnets_count}"
  ami                 = data.aws_ami.Amazon_Linux2.image_id
  instance_type       = var.ec2_type
  tenancy             = "default"
  key_name            = aws_key_pair.generated_key.key_name
  hibernation         = false
  availability_zone   = "${element(data.aws_availability_zones.available.names.*, count.index)}"

  network_interface {
    network_interface_id = "${element(aws_network_interface.private.*.id, count.index)}"
    device_index         = 0
  }

  tags                = {
      "Name"          = "${var.private_ec2_name}${count.index + 1}"
      "Project"       = "${var.aws_project_name}"
      "HostName"      = "privatehost1.${var.ec2_gitlab_domain}"

  }
}

resource "local_file" "inventory" {
  content = templatefile("inventory.tmpl",
    {
      servers       = data.template_file.aws_ec2_servers.*.rendered
      ssh_key       = local.ssh_key_file_name
      ansible_user  = var.ec2_user_name
    }
  )
  file_permission  = "0600"
  filename = format("%s/%s", abspath(path.root), "inventory.ini")
}

