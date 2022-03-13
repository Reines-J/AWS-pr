import boto3

ec2_re = boto3.resource("ec2")
ec2_cli = boto3.client("ec2")
waiter = ec2_cli.get_waiter("instance_running")

all_instance = []
for instance in ec2_re.instances.all():
    all_instance.append(instance.id)
print("starting all instances ....")
ec2_re.instances.start()
waiter.wait(InstanceIds=all_instance)
print("your all instances are up and running")

all_instance = []
f1={"Name": "", "Values":[""]}

for instance in ec2_re.instances.filter(Filters=[f1]):
    all_instance.append(instance)

print(all_instance)
print("-------------------")
for instances in ec2_cli.describe_instances(Filters=[f1])["Reservations"]: 
    for instance in instances["Instances"]:
        all_instance.append(instance["InstanceId"])

ec2_cli.start_instances(InstanceIds=all_instance)
waiter.wait(InstanceIds=all_instance)
print("your all instances are up and running")