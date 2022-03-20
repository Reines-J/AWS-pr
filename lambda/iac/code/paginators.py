import boto3

iam = boto3.resource("iam")
cnt=1
for user in iam.meta.client.list_users()["Users"]:
    print(cnt, user["UserName"])
    cnt+=1

paginator = iam.get_paginator("list_users")
for page in paginator.paginate():
    for user in page["Users"]:
        print(cnt, user["UserName"])
        cnt+=1

ec2 = boto3.resource("ec2")
paginator = ec2.meta.client.get_paginator("describe_instances")
for page in paginator.paginate():
    print(page)
