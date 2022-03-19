rdt_gov_assumerole_rdt_developer_arn  = "arn:aws-us-gov:iam::812769740018:role/RDT_Developer"
rdt_gov_account_id         = "812769740018"
rdt_gov_account_arn        = ""
sgss_gov_main_account_id   = "357462274333"
sgss_gov_main_account_arn  = "arn:aws-us-gov:iam::357462274333:root"

aws_profile                = "terraform"
public_ec2_name            = "AWS-GitLab-"
ec2_type                   = "t3.medium"
private_ec2_name           = "PrivateHost-"
ec2_hostname               = "gitlab"
ec2_gitlab_domain          = "dev.sgss.nrl.network"
ec2_user_name              = "ec2-user"
aws_project_name           = "RDT_CDO_AWS_Gitlab"
key_pair_name              = "sgss_alx_key_pair_default"
remote_ipaddress           = ["96.255.55.4/32","70.168.178.194/32","172.58.228.37/32"]
# 70.168.178.194  ALX Office
#Use the new values for ami
ami_owners                 = ["045324592363"]
ami_name_regex             = "amzn2-ami-hvm-2.0.20220207.1-x86_64-gp2"
#  Networking vars

vpc_cidr                   = "172.31.0.0/16"
private_subnets_count      = 2
public_subnets_count       = 2
public_subnets_cidr        = "172.31.0.0/16"
private_subnets_cidr       = "172.31.48.0/16"
subnet_bit                 = 4


# public_subnets_cidr        = ["172.31.0.0/20",  "172.31.16.0/20"]
# private_subnets_cidr       = ["172.31.48.0/20", "172.31.64.0/20"]
