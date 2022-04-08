## 17 February 2022
  * JA contributed a bare-bones TF config, using s3 backend.
## 9 March 2022
  * Base code to create a seconday VPC and 2 subnets on each available zones, one private subnet and on public subnet, still hardcoded to create only 2 EC2 instances on the first two available zones.
## 11 March 2022
  * Creates one EC2 instance in a public  area defined in variable public_subnet_cidr
  * Creates one EC2 instance in a private area defined in variable private_subnet_cidr
  * public_subnet_cidr and private_subnet_cidr are arrays containing the ip
      address, these ip address will be used to create a subnet per availability zone
  * public_subnet_cidr and private_subnet_cidr must match the cidr of the VPC (vpc_cidr)
  * Ready to setup the Application Load balancer (I hope)
## 11 March 2022
  * Bash script to automate terraform process to create instances on aws and provision them using ansible
  
