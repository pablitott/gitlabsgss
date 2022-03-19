variable "sgss_gov_main_account_id" {
    type        = string
    default     = ""
    description = "Account ID for sgss-main management account"
}

variable "sgss_gov_main_account_arn" {
    type        = string
    default     = ""
    description = "ARN for sgss-main management account"
}

variable "rdt_gov_account_id" {
    type        = string
    default     = ""
    description = "Account ID for govcloud"
}

variable "rdt_gov_account_arn" {
    type        = string
    default     = ""
    description = "ARN for govcloud account"
}

variable "rdt_gov_assumerole_rdt_developer_arn" {
    type        = string
    default     = ""
    description = "ARN for RDT govcloud account admin access"
}

variable "aws_profile" {
    type        = string
    default     = ""
    description = ""
}

###########  Networking Vars   #######
variable "vpc_cidr"{
    type         = string
    default      = ""
}

variable "private_subnets_count"{}

variable "public_subnets_count"{}
variable "subnet_bit"{
    type        = number
    default     = 4
}
variable "public_subnets_cidr"{}

variable "private_subnets_cidr"{}
##########################################################################
variable "ami_owners"{
    type        = list
    default     = []
}

variable "ami_name_regex"{
    type        = string
    default     = ""
    description = ""
}

variable "ami_owner_alias"{
    type        = list
    default     = []
}


variable "ami_architecture"{
    type        = list
    default     = []
}
###########################################################################

variable "aws_project_name"{
    type        = string
    default     = ""
    description = "Project name tp identify resources related"
}

variable "ec2_type"{
    type        = string
    default     = ""
    description = "Default instance type used for gitlab EC2 instances"
}

variable "key_pair_name"{
  type          = string
  default       = ""
  description   = "Key pait name to be created and used to connect to all instances"
}
variable "remote_ipaddress"{
    type        = list
    default     = []
    description = "name of the ec2-instance base"
}
variable "public_ec2_name"{
    type        = string
    default     = ""
    description = "name of the ec2-instance base"
}

variable "private_ec2_name"{
    type        = string
    default     = ""
    description = "name of the ec2-instance base"
}

variable "ec2_hostname"{
    type        = string
    default     = ""
}

variable "ec2_user_name"{
    type        = string
    default     = ""
    description = "Use name to be used to connect to all instances"
}

variable "ec2_gitlab_domain"{
    type        = string
    default     = ""
    description = "This is the domain name for public access"
}

locals {
  ssh_key_file_name = "~/.ssh/${var.key_pair_name}.pem"
  inventory_file_permission  = "600"
  inventory_folder_permission = "700"
  # remote_ssh_ingress is enabled when remote_ipaddress is an array
  remote_ssh_ingress = length(var.remote_ipaddress)==0 ? 0: 1
}