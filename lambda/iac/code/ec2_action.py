import boto3
import sys

ec2_re = boto3.resource("ec2")
ec2_cli = boto3.client("ec2")

while True:
    print("This script performs the following actions on ec2 instance")
    print("1.start\n" +"2.stop\n"+"3.terminate\n"+"4.Exit\n")
    opt = int(input("Enter your option:"))
    if opt == 1:
        instance_id = input("Enter your EC2 Instance Id: ")
        req_instance = ec2_re.Instance(instance_id)
        print("Starting ec2 instance.....")
        req_instance.start()
    elif opt ==2:
        instance_id = input("Enter your EC2 Instance Id: ")
        req_instance = ec2_re.Instance(instance_id)
        print("Stopping ec2 instance.....")
        req_instance.stop()
    elif opt ==3:
        instance_id = input("Enter your EC2 Instance Id: ")
        req_instance = ec2_re.Instance(instance_id)
        print("Terminating ec2 instance.....")
        req_instance.terminate()
    elif opt ==4:
        print("Thank you for using this script")
        sys.exit()
    else:
        print("Your option is invalid. Please try once again")
