variable "allowed_cidr_blocks" {
  type = list
}

# variable "certificate_arn" {}

# Imported vpc instance
variable "rdt_vcp" {}

variable "aws_project_name" {}

variable "subnet_public" {}

variable "subnet_private" {}

variable "gitlab_ami_base" {}

variable "ec2_type" {}

variable "key_name" {}

variable "security_groups" {}

variable "private_ec2_name" {}
