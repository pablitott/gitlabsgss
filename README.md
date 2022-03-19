# RDT Cross-Domain DevSecOps Prototype

## Console access to RDT as Developer

If you have signed in to the SGSS GovCloud account and you are an RDT_Developer, you can use this link to access the RDT AWS account console as developer:
https://signin.amazonaws-us-gov.com/switchrole?roleName=RDT_Developer&account=812769740018

## Getting started with access to this project

This project is hosted in SGSS's RDT GovCloud account, in a git repository hosted in CodeCommit.  To gain access you will need:

1. A git client
2. Access credentials to sgss-main AWS account
3. A user account with RDT_Developer access
4. Install [git-remote-codecommit](https://docs.aws.amazon.com/codecommit/latest/userguide/temporary-access.html?icmpid=docs_acc_console_connect#tc-role).
5. Configure your AWS credentials for codecommit access using your account

In `~/.aws/credentials` you need a stanza that looks like:

    [sgss-gov]
    # for IAM user user.name in sgss-main, govcloud, AWS account ID 357462274333
    aws_access_key_id = **put your access key ID here**
    aws_secret_access_key = **put your secret key here**

In `~/.aws/profile` you need two stanzas like:

    [profile sgss-gov]
    # for jonathan.anderson, sgss-main, gov, 357462274333
    region = us-gov-east-1

    [profile rdt-gov-developer]
    # grants STS:AssumeRole access from 357462274333 to the RDT_Developer role in rdt-govcloud 812769740018
    source_profile = sgss-gov
    region = us-gov-east-1
    role_session_name = user.name
    role_arn = arn:aws-us-gov:iam::812769740018:role/RDT_Developer

Instructions for [configuring your local environment for codecommit access are here](https://docs.aws.amazon.com/codecommit/latest/userguide/temporary-access.html?icmpid=docs_acc_console_connect#tc-role).

## Windows Dev Prerequisites

1. Install Python3 - https://www.python.org/downloads/release/python-3102/ or latest stable from https://www.python.org/downloads/windows/ 
2. Install PIP
3. Then install git-remote-codecommit.exe*


## Branches
   - main - the production line of the project
   - devel - please do all your development work on this branch for now

## Cloning the project

    git clone codecommit::us-gov-east-1://rdt-gov-developer@rdt-cdo
    git checkout devel