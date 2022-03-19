terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
   }
  }
}

  ## This stanza configures Terraform to store state in an S3 bucket and use the
  ## given dynamodb table as a lock.  The specified s3 bucket and the dynamodb table
  ## were created by the rdt_infrastructure code.

#   backend "s3" {
#     profile = "sgss-gov-mgmt"
#     bucket = "sgss-rdt-terraform-state"
#     key    = "state/rdt-cdo/terraform_state.tfstate"
#     region = "us-gov-east-1"
#     dynamodb_table = "terraform_state"
#     encrypt        = "true"
#     role_arn = "arn:aws-us-gov:iam::812769740018:role/RDT_Developer"
#   }

# }

## This is useful when manipulating Amazon ARNs, because in govcloud the partition name
## is different than the rest of AWS.
# data "aws_partition" "current" {}
