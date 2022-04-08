# assuming workdir = /home/user/projectName/scripts
workdir=$PWD
if [[ "$1" == '' ]]; then 
    echo "Please provide an action: provision/deploy"
    exit 1
fi

#  provision will:
#     create the infrastructure for gitlab, 
#     create a ec2 instance base to create the ami image
if [ $1 == "provision" ]; then
    terraform -chdir=../tf apply

# Install the gitlab software inti the ec2-instance
# terraform will output the root password, login into the gitlab-base-for-ami
# and change the password for root
elif [[ $1 == 'install' ]]; then
    cd $workdir/../ansible
    cp ../tf/inventory.ini inventory.ini
    ansible-playbook playbooks/main.yml -i inventory.ini

#  deploy: will create the ami image based on the provision above
elif [[ $1 == 'deploy' ]]; then
    # delete the existing gitlab-ami 
    temp=$(aws ec2 describe-images \
        --owner self --query 'Images[?Name==`gitlab-ami`]' \
        --profile rdt-gov-developer \
        --output json | jq '.[].ImageId')
    imageId=`echo $temp | sed 's/.\(.*\)/\1/' | sed 's/\(.*\)./\1/'`
    echo "Image ID: $imageId"
    aws ec2 deregister-image --image-id $imageId --profile rdt-gov-developer


    terraform -chdir=../tf apply -replace='aws_ami_from_instance.gitlab_ami_base["gitlab-ami"]'
fi
cd $workdir

# every time you change the content of the ec2 instance "gitlab-base-for-ami", you have to replace 
# the ami base using 
#  terraform apply -replace='aws_ami_from_instance.gitlab_ami_base["gitlab-ami"]'

# in order to the launch instances use the new gitlab image 
# you must stop the existing one and allow the system recreate the launch instances