import boto3

sts_cli = boto3.client("sts")
response_sts = sts_cli.get_caller_identity()
print(response_sts.get("Account"))

aws_mag_test = boto3.Session("testboto")
sts_con_cli = aws_mag_test.client("sts")
response_con_sts = sts_con_cli.get_caller_identity()
print(response_con_sts["Acocount"])