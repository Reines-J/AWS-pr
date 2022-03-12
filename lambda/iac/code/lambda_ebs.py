import boto3
from pprint import pprint

def lambda_handler(event, context):
    ec2 = boto3.client("ec2")
    all_region = []
    for region in ec2.describe_regions()["Regions"]:
        all_region.append(region.get("RegionName"))

    for region in all_region:
        print(f"Workin on {region}")
        ec2 = boto3.client(service_name="ec2", region_name=region)

        all_volume = []
        para1 = {"Name": "tag:Prod", "Values": ["backup", "Backup"]}

        for volume in ec2.describe_volumes(Filters=[para1])["Volumes"]:
            all_volume.append(volume["VolumeId"])


        paginator = ec2.get_paginator("describe_volumes")
        for page in paginator.pagiante(Filters=[para1]):
            for volume in page["Volumes"]:
                all_volume.append(volume["VolumeId"])
        
        print(f"The list of volids are: {all_volume}")
        if bool(all_volume) == False:
            continue
        snapids=[]
        for volume_id in all_volume:
            print(f"Taking snap of {volume_id}")
            res = ec2.create_snapshot(
                Description="Taking snap with Lambda and cw", 
                VolumeId=volume_id,
                TagsPecifications=[
                    {
                        "ResourceType": "snapshot",
                        "Tags" : [
                            {
                                "key" : "Delete-on",
                                "value": "90"
                            }
                        ]
                    }
                ]
                )
            snapids.append(res.get("SnapshotId"))
        print(f"The snap ids are {snapids}")
        waiter = ec2.get_waiter("snapshot_completed")
        waiter.wait(SnapshotIds=snapids)
        print(f"Successfully completed snaps for the volumes of {all_volume}")