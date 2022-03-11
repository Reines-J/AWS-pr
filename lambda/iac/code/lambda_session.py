import boto3

sts = boto3.client("sts")
assume_role = sts.assume_role(
    RoleArn="",
    RoleSessionName=""
)

def lambda_handler(event, context):
    ec2 = boto3.resource("ec2")
    for instance in ec2.instances.all():
        print(instance.id)
    s3 = boto3.resource("s3") #error not inlcude s3 policy 