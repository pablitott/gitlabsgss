# Reference: https://medium.com/appgambit/terraform-aws-vpc-with-private-public-subnets-with-nat-4094ad2ab331
# Imported vpc instance
variable "rdt_vcp" {}

variable "vpc_cidr" {}
variable "availability_zones"{
    type        = list
    default     = []
}

variable "public_subnets_cidr"{
    type        = list
    default     = []
}

variable "private_subnets_cidr"{
    type        = list
    default     = []
}

variable "aws_project_name"{
    type        = string
    default     = ""
    description = "Project name tp identify resources related"
}

