import boto3
import sys

def lambda_handler(event, context):
    master_id=""
    slave_id=""
    ec2 = boto3.resource("ec2")
    primary_instance = ec2.Instance(master_id)
    if primary_instance.state["Name"] == "running":
        print("Master is running so no modifications")
    else:
        secondary_instance = ec2.Instance(slave_id)
        pnet_info = primary_instance.network_interfaces_attribute[0]
        snet_info = secondary_instance.network_interfaces_attribute[0]
        pnet_id = pnet_info["NetworkInterfaceId"]
        snet_id = snet_info["NetworkInterfaceId"]
        secondary_ip = ""

        ec2.meta.client.unassign_private_ip_addresses(
            NetworkInterfaceId = pnet_id,
            PrivateIpAddresses = [secondary_ip]
        )

        ec2.meta.client.assign_private_ip_addresses(
            AllowReassignment = True,
            NetworkInterfaceId = snet_id,
            PrivateIpAddresses = [secondary_ip]
        )
    return None
