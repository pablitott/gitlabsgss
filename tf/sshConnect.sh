# Connect to an EC@ instance withot adding the key into known_hot file 
echo $1
ssh ec2-user@$1 -i ~/.ssh/sgss_alx_key_pair_default.pem  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
