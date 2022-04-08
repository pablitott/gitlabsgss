# Terraform for Gitlab
## Introduction
This script is designed to create a Gitlab Infrstructure into AWS, to be used you need follwoing pre-requisites
1. An .AWS folder with followig files/information
    config
       a. AWS profile
       b. default region
    credentials
        aws_access_key_id=xxxxxxxxxx
        aws_secret_access_key=xxxxxxxxxxxxxxxxxxxxxxx
    profile
        source_profile = sgss-gov
        region = us-gov-east-1/us-gov-east-2/etc
        role_session_name = user name
        role_arn = <`arn for user`>
2. Infrastructure created
    - The main.tf script is designed to create 2 public subnets and 2 private subnets, one EC2 instance on each public subnet to be used as a bastion hosts to maintain and troubleshoot the ALB instances 
    - in will create an ALB (Amazon Load Balancer) pointing to the private subnets, with specific number to instances, alb_min_size, alb_max_size, alb_desired_capacity.
    - it will create an EC2 Instance located in one of the public subnets named "__gitlab-base-for-ami__", which will be provided with the Gitlab software, this EC2 Instance witll be used as a base to create an AMI image called "__Gitlab-ami__"

2. Main terms
    - ami_image is the name of the AMI image to be created default: __Gitlab-ami__
3. exports:
    The Main script will show the ip for the public instances and:
    - file: inventory.ini to be used by ansible with the format required by ansible
    - the alb end point used to open the gitlab instances actually:
    > Gitlab-ALB-228336950.us-gov-east-1.elb.amazonaws.com
3. Usage:
>    terraform apply -var ami_gitlab_base=[]
    declaring providing ami_gitlab_base=[] prevent the script to create the AMI image
>    terraform apply
    command above create the AMI image if it does not exists
4. full process
    An script <git base>/scripts/aws_rebuild.sh is used to create the whole process as:  
    a. cd <`git base`>/scripts  
    b. ./aws_rebuild.sh <action>  
       i. action is one of provision/deploy
    
    provision: 
    - will create the whole infraestructure ALB/subnets/EC2 instances, security groups, ssh-key-pairs, etc
    - Create the EC2 instansce base for the Gitlab AMI
    - Provision the EC2-Instance base for the AMI
    deploy:
    - Create an AMI image based on the EC2-instance created above

5. Improvements
    - Execute the whole script in one step
    - Remove remianing hard code







