data "aws_ami" "Amazon_Linux2"{
  most_recent = true
  owners        = ["137112412989"]
  name_regex    = "^amzn-ami-hvm*"
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "template_file" "aws_ec2_names" {
  count    = "${length(aws_instance.publichost)}"
  template = "${lookup(aws_instance.publichost.*.tags[count.index], "Name")}"
}

data "template_file" "aws_ec2_hostname" {
  count    = "${length(aws_instance.publichost)}"
  template = "${lookup(aws_instance.publichost.*.tags[count.index], "HostName")}"
}

#TODO: find a better way to create the template string
data "template_file" "aws_ec2_servers" {
  count    = "${length(aws_instance.publichost)}"
  # ${length("aws_instance.publichost.*" )}
  template = "${lookup(aws_instance.publichost.*.tags[count.index], "Name")}    ansible_ssh_host=${aws_instance.publichost.*.public_ip[count.index]}  server_host_name=${lookup(aws_instance.publichost.*.tags[count.index], "HostName")}"

}

