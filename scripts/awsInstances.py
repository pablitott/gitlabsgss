import logging
import sys
import boto3
from botocore.exceptions import ClientError
# import ec2_instance_management

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

logger = logging.getLogger(__name__)

AWS_PROFILE_NAME="rdt-gov-developer"
AWS_DEFAULT_PROJECT='RDT_CDO_AWS_Gitlab'
session = boto3.session.Session(profile_name=AWS_PROFILE_NAME)
ec2client = session.client('ec2')


######################################################################
# Function: getEc2IpAddress                                          #
#                                                                    #
# Description: Get EC2 Ip address by Tag value                       #
#                                                                    #
# Arguments: TagName, TagValue                                       #
#                                                                    #
# TagName is the EC2 Tag Name e.g. Name, Project                     #
# TagValue: e.g. Instance Name: AWS-GitLab-1 or                      #
#                Project: RDT_CDO_AWS_Gitlab                         #
#                or any other tag value                              #
#                                                                    #
######################################################################
def getEc2Instance(keyName, keyValue):
    if len(keyName)==0:
        logger.exception("Not enough arguments")
    
    response = ec2client.describe_instances(
        Filters=[
                {
                    'Name': 'tag:'+keyName,
                    'Values': [keyValue]
                }
            ]
        )

    return response
######################################################################
def getEc2IpAddress(InstanceName):
    response=getEc2Instance('Name', InstanceName)
    instanceArray = []
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            instanceArray.append(instance["PublicIpAddress"])
    
    return instanceArray
######################################################################
#                                                                    #
#   Get the EC2 Instance Ids for project
#                                                                    #
######################################################################
def getEc2Id(InstanceName):
    response=getEc2Instance('Name', InstanceName)

    instancelist = []
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            instancelist.append(instance["InstanceId"])

    return instancelist
#=====================================================
def stop_instance(instanceId):
    """
    Stops an instance. The request returns immediately. To wait for the instance
    to stop, use the Instance.wait_until_stopped() function.

    :param instanceId: The ID of the instance to stop.
    :return: The response to the stop request. This includes both the previous and
             current state of the instance.
    """
    try:
        ec2 = session.resource('ec2')
        response = ec2.Instance(instanceId).stop()
        logger.info("Stopped instance %s.", instanceId)
    except ClientError:
        logger.exception("Couldn't stop instance %s.", instanceId)
        raise
    else:
        return response
#################################################################################
def state_instance(InstanceName):
    if len(InstanceName)==0:
        logger.exception("Not enough arguments")

    instanceId=getEc2Id(InstanceName)[0]
    if instanceId==None:
        logger.exception( InstanceName + " not exists")

    response = ec2client.describe_instances(
        Filters=[
                {
                    'Name': 'tag:Name',
                    'Values': [InstanceName]
                }
            ],
        InstanceIds=[ instanceId ],
        )

    instancelist=[]    
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            instancelist.append(instance["State"]["Name"])

    return instancelist
#################################################################################
def start_instance(instanceId):
    """
    Stops an instance. The request returns immediately. To wait for the instance
    to stop, use the Instance.wait_until_stopped() function.

    :param instanceId: The ID of the instance to stop.
    :return: The response to the stop request. This includes both the previous and
             current state of the instance.
    """
    try:
        ec2 = session.resource('ec2')
        response = ec2.Instance(instanceId).start()
        logger.info("Stopped instance %s.", instanceId)
    except ClientError:
        logger.exception("Couldn't stop instance %s.", instanceId)
        raise
    else:
        return response
#################################################################################
if __name__ == "__main__":
    try:
        project=sys.argv[1]
        ec2Instance=sys.argv[2]
    except IndexError as  e:
        # # print(f"{bcolors.FAIL}Error:{bcolors.ENDC} Not enough arguments passed.")
        sys.exit(f"{bcolors.FAIL}ERROR:{bcolors.ENDC} Not enough arguments passed.")
        raise 
    # raise

# AWS_DEFAULT_PROJECT='RDT_CDO_AWS_Gitlab'
# TEST_EC2_INSTANCE='AWS-GitLab-1'

print( ec2Instance + " State: " + state_instance( ec2Instance )[0] )

print( ec2Instance + " Id: " + getEc2Id(ec2Instance)[0] )

print( ec2Instance + " IP Address: " + getEc2IpAddress(ec2Instance)[0] )


