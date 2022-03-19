
02/16/2022
Project Name: GitLab on AWS
Author: Pablo Trujillo
email: ptrujillo@sgss.com

Project based on:
1. [Install self-managed gitlab](https://about.gitlab.com/install/#centos-7)
2. [Ansible Role gitlab](https://github.com/geerlingguy/ansible-role-gitlab)

to setup dns name in a non production environment use [nip.io](https://nip.io/) which allows you to mapping any IP Address to a hostname using different formats [see nip.io](https://nip.io/), get the code from [exentrique solution nip.io](https://github.com/exentriquesolutions/nip.io), or a full example from [resmo nip.io](https://github.com/resmo/nip.io).  

an alternative to tredirect always to 127.0.0.1 is [local.gd](https://local.gd/), is the same as nip.io but always pointed to the local host 127.0.0.1



02/17/2022
### AWS Settings for GitLab project
Following settings were used to create the EC2 instance named: RHEL-7.9-GitLab
---
| Property | Value|
|--------- |------|
| Name     | RHEL-7.9-GitLab |
| Instance Id | i-0004b13835b113dbd |
| Public Ip | 18.253.104.90 |
| Public DNS | ec2-18-253-104-90.us-gov-east-1.compute.amazonaws.com |
| Subnet | subnet-0e68a974f89273564 |
| vpc id | vpc-047d5957b5f663025 |
| AMI Id | ami-547a9325 |
| Key Pair Name | sgss_alx_personal (see note) |
| Network Id | eni-0c79d2065c6d0290f |
| Network ACL |  acl-0f104ccafa19c9f2c |
| Security Group ID | sg-0780573b5c7203e36 - ALX SSH |
| Security Group Rule ID | sgr-07363a65a89a5070a |
| Route Table | rtb-082d27133ab1a2b64 |
| Gateway | igw-0561cdca53a87a2dc |
---

ask for sgss_alx_personal.pem to gain access to this instance to the author
SSH remote
> ssh ec2-user@ec2-18-253-104-90.us-gov-east-1.compute.amazonaws.com -i ~/.ssh/sgss_alx_personal.pem 

### prerequisites
* [Gitlab-install-notes.txt](./Gitlab-install-notes.txt) for reference
* [bootstrap.sh](./bootstrap.sh) for automated process
  
