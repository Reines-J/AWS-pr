import json
import boto3

ec2 = boto3.resource("ec2")

def lambda_handler(event, context):
    print(event)
    ec2.Instance(event["detail"]["instance-id"]).start()
    print("Instance ID: " + event["detail"]["instance-id"]+"Started!")
    