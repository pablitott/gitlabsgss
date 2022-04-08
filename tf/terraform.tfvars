ec2_type                   = "t3.medium"
public_ec2_name            = "AWS-Bastion-"
public_ec2_hostname        = "bastion"
private_ec2_name           = "AWS-Gitlab-"
private_ec2_hostname       = "gitlab"
ec2_gitlab_domain          = "gitlab.dev.sgssnrl.network"
ec2_user_name              = "ec2-user"
aws_project_name           = "RDT_CDO_AWS_Gitlab"
key_pair_name              = "sgss_alx_key_pair_default"
# Remote developer locations change for the one in ALX or developer location
remote_ipaddress           = ["96.255.55.4/32","70.168.178.194/32","172.58.228.37/32"]
alb_min_size               = 1
alb_max_size               = 1
alb_desired_capacity       = 1

vpc_cidr                   = "10.4.0.0/16"
public_subnets_cidr        = ["10.4.10.0/24", "10.4.11.0/24"]
private_subnets_cidr       = ["10.4.12.0/24", "10.4.13.0/24"]

