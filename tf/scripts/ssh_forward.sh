sudo sed -i 's/#AllowAgentForwarding yes/AllowAgentForwarding yes' /etc/ssh/ssh_config
sudo service sshd restart
