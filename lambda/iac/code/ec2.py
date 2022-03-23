import boto3
from pprint import pprint

ec2_cli = boto3.client("ec2")

response_ec2 = ec2_cli.describe_instances()
#pprint(response_ec2)

for instances in response_ec2["Reservations"]:
    for instance in instances["Instances"]:
        print(f"The Image Id is {instance['ImageId']}\n"+
        f"The Instance ID iS {instance['InstanceId']}\n"+
        f"The Instance Launch Time is {instance['LaunchTime'].strftime('%Y-%m-%d')}")

response_ebs = ec2_cli.describe_volumes()["Volumes"]
#pprint(response_ebs)

for volumes in response_ebs:
    print(f"The volume id is {volumes['VolumeId']}\n"+
    f"The AvailabilityZone is {volumes['AvailabilityZone']}\n" +
    f"The VolumeType is {volumes['VolumeType']}"
    )