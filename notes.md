[assign different zones](https://stackoverflow.com/questions/69691331/terraform-create-ec2-instances-in-each-availability-zone)

# GitLab CDO
## terraform project
## Connect to private instances with SSH
source: [ssh into ec2 in private subnet](https://digitalcloud.training/ssh-into-ec2-in-private-subnet/)
* Bastion host security group needs to allow SSH from the client computer
	And outbound to the private EC2 instance
* The private EC2 Instance must allow inbound SSH from the public instance security group 
* On the client run:
	> ssh-add -K myPrivateKey.pem
  You should see a result like this:
	> Identity Added: myPrivateKey.pem (myPrivateKey.pem) 
* Configure the ssh agent on linux
	> ssh add -L myPrivateKey.pem
	output must be similar as above
* Connect to the bastion 
	> ssh –A ec2-user@<bastion-IP-address or DNS-entry>
* Now that you’ve used agent forwarding you can simply connect to any instance that is using the same key pair by simply issuing the following command:
	> ssh ec2-user@<instance-IP-address or DNS-entry>



### Resources created 
Following resources where created using terrasight apply, keep the list for security purposes
1.	data.aws_ami.Amazon_Linux2
2.	data.aws_availability_zones.available
3.	data.aws_partition.current
4.	data.template_file.aws_ec2_hostname[0]
5.	data.template_file.aws_ec2_hostname[1]
6.	data.template_file.aws_ec2_names[0]
7.	data.template_file.aws_ec2_names[1]
8.	data.template_file.aws_ec2_servers[0]
9.	data.template_file.aws_ec2_servers[1]
10.	aws_instance.publichost[0]
11.	aws_instance.publichost[1]
12.	aws_instance.privatehost[0]
13.	aws_instance.privatehost[1]
14.	aws_key_pair.generated_key
15.	aws_network_interface.private[0]
16.	aws_network_interface.private[1]
17.	aws_network_interface.public[0]
18.	aws_network_interface.public[1]
19.	aws_security_group.RemoteAccess
20.	aws_security_group.all_ssh
21.	aws_security_group.remote_ssh
22.	aws_security_group_rule.AllowAllTraffic
23.	aws_security_group_rule.sgr_all_ssh[0]
24.	aws_security_group_rule.sgr_remote_ssh[0]
25.	local_file.inventory
26.	local_file.ssh_key_file
27.	tls_private_key.ssh
28.	module.networking.aws_eip.nat_eip
29.	module.networking.aws_internet_gateway.ig
30.	module.networking.aws_nat_gateway.nat
31.	module.networking.aws_route.private_nat_gateway
32.	module.networking.aws_route.public_internet_gateway
33.	module.networking.aws_route_table.private
34.	module.networking.aws_route_table.public
35.	module.networking.aws_route_table_association.private[0]
36.	module.networking.aws_route_table_association.private[1]
37.	module.networking.aws_route_table_association.public[0]
38.	module.networking.aws_route_table_association.public[1]
39.	module.networking.aws_security_group.default
40.	module.networking.aws_subnet.private_subnet[0]
41.	module.networking.aws_subnet.private_subnet[1]
42.	module.networking.aws_subnet.public_subnet[0]
43.	module.networking.aws_subnet.public_subnet[1]
44.	module.networking.aws_vpc.vpc
