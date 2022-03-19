yum update -y
yum install -y curl policycoreutils-python openssh-server perl yum-utils stunnel
# Enable OpenSSH server daemon 
systemctl status sshd
systemctl enable sshd
systemctl start sshd

# Check if opening the firewall is needed with: sudo systemctl status firewalld
systemctl status firewalld
yum install firewall-config -y
systemctl unmask firewalld
systemctl start firewalld
systemctl enable firewalld

# Enable http and https services
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
systemctl reload firewalld


#Install postfix
sudo yum install postfix
sudo systemctl enable postfix
sudo systemctl start postfix

#Add the GitLab package repository.
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash


hostname 
#hostnamectl --static set-hostname foo.bar.com
#ip-172-31-36-222.us-gov-east-1.compute.internal


#execute the following
# EXTERNAL_URL=http://gitlabansible.gitlab.local yum localinstall -y gitlab-ee-14.6.2-ee.0.el7.x86_64.rpm
EXTERNAL_URL=http://gitsgss.sgss.aws yum localinstall -y gitlab-ee-14.6.2-ee.0.el7.x86_64.rpm
