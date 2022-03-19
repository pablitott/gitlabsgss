###################################################################
#                                                                 #
#                       awsConnect.sh                             #
#                                                                 #
# Use this script to avoid add the ssh host into known_hosts file #
#                                                                 #
# To use these function execute ./scripts/awsCommands.sh          #
# To Use functions the commands must be run from git root         #
###################################################################

# temporaly hardcoded 
function sshConnect(){
    # tested
    ssh ec2-user@$1 -i ~/.ssh/sgss_alx_key_pair_default.pem  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
}

