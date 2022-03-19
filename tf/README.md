# Terraformation

## Prerequisites

1. Need to have recent terraform executable in your path.  Download from https://www.terraform.io/downloads
2. Need to have correct aws credentials configured in your ~/.aws directory, example below

In `~/.aws/config`

        ## Note that the profile name here must match what is in `providers.tf` and in `backend.tf` in the 
        ## s3 backend stanza

        [profile sgss-gov-mgmt]
        # for user.name, gov, 357462274333 (this is the sgss-main govcloud account)
        region = us-gov-east-1

In `~/.aws/credentials`

        [sgss-gov-mgmt]
        # for user.name
        aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
        aws_secret_access_key = KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK

Note that the profile and credentials here are for the sgss-main account.  Setting the deployment for this project
to apply in the RDT subaccount and using the RDT_Developer role happens in the aws provider stanza in `provider.tf`,
in `assume_role`.  A similar entry appears in the backend configuration.

## Initializing

    # cd rdt-cdo/tf
    # terraform init
    
    Initializing the backend...

    Successfully configured the backend "s3"! Terraform will automatically
    use this backend unless the backend configuration changes.

    Initializing provider plugins...
    - Finding hashicorp/aws versions matching "~> 3.0"...
    - Installing hashicorp/aws v3.74.3...
    - Installed hashicorp/aws v3.74.3 (signed by HashiCorp)

    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.

## Usage example

    # terraform refresh
    aws_instance.gitlab_rhel7_1: Refreshing state... [id=i-0004b13835b113dbd]

    Outputs:
    rhel7-gitlab-private-ip = "172.31.36.222"
    rhel7-gitlab-public-ip = "18.252.49.37"