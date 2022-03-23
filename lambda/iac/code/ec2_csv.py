import boto3
import csv

ec2_re = boto3.resource("ec2")
cnt = 1
with open("ec2_csv.csv", "w") as ecv:
    csv_w=csv.writer(ecv)
    ecv.write("S_NO,Instance_Id,Instance_Type,Architecture,LaunchTime,Private_Ip")
    for instance in ec2_re.instances.all():
        print(cnt, instance, instance.instance_id, instance.instance_type, instance.architecture, instance.launch_time.strftime("%Y-%m-%d"), instance.private_ip_address)
        ecv.write(f"\n{cnt},"f"{instance.instance_id},"f"{instance.instance_type},"f"{instance.architecture},"f"{instance.launch_time.strftime('%Y-%m-%d')},"f"{instance.private_ip_address}")
        cnt+1
        