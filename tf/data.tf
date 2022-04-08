data "aws_ami" "Amazon_Linux2"{
  most_recent = true
  owners        = ["${var.ami-amazon-owner}"]
  name_regex    = "${var.ami-amazon-pattern}"
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# get the list of
data "aws_ami" "gitlab_base" {
    most_recent = true
    # if does not exists a private AMI, use the Amazon public AMI as the one above
    owners = ["${var.ami_gitlab_owner}","${var.ami-amazon-owner}"]
    name_regex = "${var.ami_gitlab_pattern}|${var.ami-amazon-pattern}"

}

data "aws_availability_zones" "available" {
  state = "available"
}

data "template_file" "aws_ec2_names" {
  template = "${lookup(aws_instance.gitlab.tags, "Name")}"
}

data "template_file" "aws_ec2_hostname" {
  template = "${lookup(aws_instance.gitlab.tags, "HostName")}"
}

data "template_file" "aws_ec2_servers" {
  template = "${lookup(aws_instance.gitlab.tags, "Name")}    ansible_ssh_host=${aws_instance.gitlab.public_ip}  server_host_name=${lookup(aws_instance.gitlab.tags, "HostName")}"
}

