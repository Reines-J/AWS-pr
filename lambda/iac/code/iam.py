import datetime
import boto3

iam_re = boto3.resource("iam")
iam_user = iam_re.User("testboto3")
print(iam_user.user_name, iam_user.user_id, iam_user.arn, iam_user.create_date.strftime('%Y-%m-%d'))

for users in iam_re.users.all():
    print(users.name)
    print(users.user_name, users.user_id, users.arn, users.create_date.strftime('%Y-%m-%d'))