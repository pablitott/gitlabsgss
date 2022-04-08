#######################################################################
#                                                                     #
#                   bootstrap.sh                                      #
#                                                                     #
# Description                                                         #
# Script used to install packages required to install gitlab          #
# in a single instance                                                #
# Requires an Amazon AWS image                                        #
#                                                                     #
# Require elevated privileges to apply                                #
#                                                                     #
#######################################################################
# This script is working properly on virtual box centos/7

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
#sudo hostnamectl set-hostname sgssgitlab.sgss.aws
EXTERNAL_URL="https://sgssgitlab.sgss.aws" yum install -y gitlab-ee --rpmverbosity debug

cat << EOT >> /etc/stunnel/ldaps.conf
options = NO_SSLv2
sslVersion = TLSv1.2

[ldaps]
client = yes
accept = 389
connect = idm.bar.com:636 
EOT


cat << EOT >> /etc/systemd/system/stunnel@.service
[Unit]
Description=SSL tunnel for network daemons
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target
Alias=stunnel.target

[Service]
Type=forking
ExecStart=/usr/bin/stunnel /etc/stunnel/%i.conf
ExecStop=/usr/bin/killall -9 stunnel

TimeoutSec=600

Restart=always
PrivateTmp=false
EOT

systemctl daemon-reload
systemctl enable --now stunnel@ldaps

# grafana must be disabled
cat << EOT >> /etc/gitlab/gitlab.rb
grafana['enable'] = false
letsencrypt['enable'] = false
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
  main: # 'main' is the GitLab 'provider ID' of this LDAP server
    label: 'LDAP'
    host: '192.168.56.120'
    port: 389
    uid: 'uid'
    bind_dn: 'uid=bind_user,cn=users,cn=accounts,dc=bar,dc=com'
    password: ''
    encryption: 'plain' # "start_tls" or "simple_tls" or "plain"
    verify_certificates: false
    base: 'cn=users,cn=accounts,dc=bar,dc=com'
    user_filter: 
'(memberOf=cn=gitlab_users,cn=groups,cn=accounts,dc=bar,dc=com)'
    EOS
EOT

gitlab-ctl reconfigure
gitlab-rake gitlab:ldap:check

cat /etc/gitlab/initial_root_password | grep Password: | awk  '{print $2}'
# OH8XeGp4SnHaDBFSYDWB42l/uNSXlz2/8wKL6h7/u8Q=
#Access gitlab as: https://sgssgitlab.sgss.aws/
