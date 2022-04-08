# https://aws.amazon.com/premiumsupport/knowledge-center/public-load-balancer-private-ec2/
################ Modules  #############################
/* networking  */
module "networking" {
  source = "./modules/networking"
    # region               = "us-east-1"
    rdt_vcp              = "${aws_vpc.rdt_vpc}"
    aws_project_name     = "${var.aws_project_name}"
    vpc_cidr             = "${var.vpc_cidr}"
    public_subnets_cidr  = "${var.public_subnets_cidr}"
    private_subnets_cidr = "${var.private_subnets_cidr}"
    availability_zones   = "${data.aws_availability_zones.available.names}"
}

/* Application Load Balancer  */
module "alb" {
  source = "./modules/alb"
    rdt_vcp              = "${aws_vpc.rdt_vpc}"
    aws_project_name     = "${var.aws_project_name}"
    allowed_cidr_blocks  = "${var.remote_ipaddress}"
    subnet_public        = "${module.networking.public_subnet}"
    subnet_private       = "${module.networking.private_subnet}"
    # certificate_arn      = "${aws_acm_certificate.cert.arn}"
    private_ec2_name     = "${var.private_ec2_name}"
    gitlab_ami_base      = "${aws_ami_from_instance.gitlab_ami_base[var.ami_gitlab_base[0]]}"

    ec2_type             = "${var.ec2_type}"
    key_name             = "${aws_key_pair.generated_key}"
    security_groups      = [
    "${aws_security_group.open_ssh.id}",
    "${aws_security_group.RemoteAccess.id}"
    ]
    # security_groups      = "${aws_security_group.RemoteAccess.id}"
}

# Imported Resource. Do not remove
resource "aws_vpc" "rdt_vpc"{
  cidr_block           = "${var.vpc_cidr}"

  tags = {
    Environment         = "PROD"
    Managed_By          = "RDT-gov"
    Name                = "RDT-vpc"
    ResponsibleParty    = "AntennaServices"
  }
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
  content               = tls_private_key.ssh.private_key_pem
}

################     main resources    #############################
resource "aws_network_interface" "public" {

  count            = "${length(var.public_subnets_cidr)}"
  subnet_id        = "${element(module.networking.public_subnet.*.id, count.index)}"

  security_groups  = [
    "${aws_security_group.remote_ssh.id}",
    "${aws_security_group.RemoteAccess.id}"
    ]

  tags = {
    "Name"         = "Public NetWork Interface ${count.index + 1}"
    "Project"      = "${var.aws_project_name}"
    "Terraform"    = true
  }
}

resource "aws_network_interface" "gitlab" {

  subnet_id        = "${element(module.networking.public_subnet.*.id, 1)}"

  security_groups  = [
    "${aws_security_group.remote_ssh.id}",
    "${aws_security_group.RemoteAccess.id}"
    ]

  tags = {
    "Name"         = "Public NetWork Interface Gitlab-ami"
    "Project"      = "${var.aws_project_name}"
    "Terraform"    = true
  }
}

resource "aws_network_interface" "private" {
  count            = "${length(var.private_subnets_cidr)}"
  subnet_id        = "${element(module.networking.private_subnet.*.id, count.index)}"
  security_groups  = [ "${aws_security_group.open_ssh.id}" ]

  tags = {
    "Name"         = "Private NetWork Interface ${count.index + 1}"
    "Project"      = "${var.aws_project_name}"
    "Terraform"    = true
  }
}
/* EC2 Instances */

resource "aws_ami_from_instance" "gitlab_ami_base" {
  for_each = { for item in var.ami_gitlab_base: item => item }
  name               = "${each.key}"
  source_instance_id = "${aws_instance.gitlab.id}"
  # depends_on         = [aws_instance.gitlab]
  tags                = {
      "Name"          = "${each.key}"
      "Project"       = "${var.aws_project_name}"
  }
}

resource "aws_instance" "gitlab" {
  ami                 = "${data.aws_ami.Amazon_Linux2.image_id}"
  instance_type       = "${var.ec2_type}"
  tenancy             = "default"
  key_name            = "${aws_key_pair.generated_key.key_name}"
  hibernation         = false
  availability_zone   = "${data.aws_availability_zones.available.names[1]}"

  network_interface {
    network_interface_id = "${aws_network_interface.gitlab.id}"
    device_index         = 0
  }

  user_data           = "../scripts/bootstrap.sh"
  tags                = {
      "Name"          = "gitlab-base-for-ami"
      "Project"       = "${var.aws_project_name}"
      "HostName"      = "${var.ec2_gitlab_domain}"

  }
}

resource "aws_instance" "publichost" {
  # NOTE: Code for private hosts  BASTION
  count               = "${length(var.public_subnets_cidr)}"
  ami                 = "${data.aws_ami.Amazon_Linux2.image_id}"
  instance_type       = "${var.ec2_type}"
  tenancy             = "default"
  key_name            = "${aws_key_pair.generated_key.key_name}"
  hibernation         = false
  availability_zone   = "${element(data.aws_availability_zones.available.names.*, count.index)}"
  user_data           = file("./scripts/ssh_forward.sh")

  network_interface {
    network_interface_id = "${element(aws_network_interface.public.*.id, count.index)}"
    device_index         = 0
  }

  tags                = {
      "Name"          = "${var.public_ec2_name}${count.index + 1}"
      "Project"       = "${var.aws_project_name}"
      "HostName"      = "${var.public_ec2_hostname}.${var.ec2_gitlab_domain}"

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
  directory_permission = "0700"
  # filename = format("%s/%s", abspath(path.root), "inventory.ini")
  filename = "inventory.ini"
}

# resource "aws_acm_certificate" "cert"{}
