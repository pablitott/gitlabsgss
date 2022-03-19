# Reference: https://medium.com/appgambit/terraform-aws-vpc-with-private-public-subnets-with-nat-4094ad2ab331
variable "vpc_cidr"{
    type         = string
    default      = ""
}

# variable "availability_zones"{
#     type        = list
#     default     = []
# }

variable public_subnets_count{}

variable private_subnets_count{}

# variable "public_subnets_cidr"{}

# variable "private_subnets_cidr"{}

variable "subnet_bit"{}
variable "aws_project_name"{
    type        = string
    default     = ""
    description = "Project name tp identify resources related"
}

# variable "public_ec2_name" {}

variable "availability_zones" {}