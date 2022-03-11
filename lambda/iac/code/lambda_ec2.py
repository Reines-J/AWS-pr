import boto3
import json

def lambda_handler(event, context):
    ec2 = boto3.resource("ec2")
    para1={"Name":"tag:Env" ,"Values":["Test"]}
    for instance in ec2.instances.filter(Filters=[para1]):
        instance.start()

def lambda_handler(event, context):
    # ec2 = boto3.resource("ec2")
    sns = boto3.client("sns")
    # instance = ec2.Instance("<>")
    # print(instance.state["Name"])
    sns.publish(TargetArn="<>", Message="Now instance is in stopped status")