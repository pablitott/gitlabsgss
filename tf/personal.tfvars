rdt_gov_assumerole_rdt_developer_arn  = ""
rdt_gov_account_id         = ""
rdt_gov_account_arn        = ""
sgss_gov_main_account_id   = ""
sgss_gov_main_account_arn  = ""
aws_profile                = "personal"

ec2_type                   = "t3.micro"
public_ec2_name            = "AWS-GitLab-"
ec2_hostname               = "gitlab"
ec2_gitlab_domain          = "dev.sgss.nrl.network"
ec2_user_name              = "ec2-user"
aws_project_name           = "RDT_CDO_AWS_Gitlab"
key_pair_name              = "sgss_alx_key_pair_default"
remote_ipaddress           = ["96.255.55.4/32","70.168.178.194/32","172.58.228.37/32"]
# 70.168.178.194  ALX Office
ami_owners                 = ["137112412989"]
ami_name_regex             = "^amzn-ami-hvm*"
ami_owner_alias            = ["amazon"]
ami_architecture           = ["x86_64"]
#  Networking vars
vpc_cidr             = "172.31.0.0/16"
subnet_bit           = 4
# public_subnets_cidr  = ["172.31.0.0/20",  "172.31.16.0/20", "172.31.32.0/20"]
# private_subnets_cidr = ["172.31.48.0/20", "172.31.64.0/20", "172.31.80.0/20"]
# availability_zones   = ["us-east-1a","us-east-1b","us-east-1c"]
# network_ip_pool      = []

