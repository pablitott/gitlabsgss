variable "ami-amazon-pattern"{
    type        = string
    default     = "^amzn-ami-hvm*"
    description = ""
}

variable "ami-amazon-owner"{
    type        = string
    default     = "137112412989"
    description = ""
}

variable "ami_gitlab_base" {
    type        = string
    default     = "gitlab-ami"
    description = ""
}

variable "ami_gitlab_pattern" {
    type        = string
    default     = "gitlab-ami*"
    description = ""
}
variable "ami_gitlab_owner" {
    type        = string
    default     = "812769740018"
    description = ""
}
