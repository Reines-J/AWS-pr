import boto3

source_region = "ap-northest-2"
dest_region = "ap-northest-1"

ec2_source = boto3.client(service_name="ec2", region_name=source_region)
sts = boto3.client("sts") 
account_id = sts.get_caller_identity().get("Account")
backup = []
para1 = {"Name": "tag:backup", "Values": ["yes"]}
for snap in ec2_source.describe_snapshots(OwnerIds=[account_id], Filters=[para1]).get("Snapshots"):
    backup.append(snap.get("SnapshotId"))
ec2_dest = boto3.client(service_name="ec2", region_name=dest_region)
for snapid in backup:
    print(f"Taking backup for id of {snapid} into a {dest_region}")
    ec2_dest.copy_snapshot(
        Description="Disator Recovery", 
        SourceRegion=source_region,
        SourceSnapshotId=snapid,
        )

print("EBS Snapshot copy to destination regio is completed")
print("Modifing tags for the snapshots for which backup is completed")

for snapid in backup:
    print("Deleting old tags")
    ec2_source.delete_tags(
        Resources=[snapid],
        Tags=[
            {
                "Key": "backup",
                "Value": "yes"
            }
        ]
    )
    print(f"Creating new tag for {snapid}")
    ec2_source.create_tags(
        Resources=[snapid],
        Tags=[
            {
                "Key": "backup",
                "Value": "completed"
            }
        ]
    )