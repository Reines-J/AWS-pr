import boto3
from random import choice
import sys

def get_iam_object():
    iam_re = boto3.resource("iam")
    return iam_re

def get_password():
    len_password=8
    chars_password="<>"
    return"".join(choice(chars_password) for char in range(len_password))
     

def main ():
    iam_re = get_iam_object
    iam_user_name = "iamboto write"
    passwrd = get_password()
    policyarn = "arn:aws:iam::aws:policy/<>"
    try:
        iam_re.meta.client.create_user(UserName=iam_user_name)
    except Exception as e:
        if e.response["Error"]["Code"] == "EntityAlreadyExists":
            print(f"Already iam user with {iam_user_name}")
            sys.exit(0)
        else:
            print("Please verify the following error and retry")
            print(e)
            sys.exit(0)
    iam_re.meta.client.create_login_profile(UserName=iam_user_name, Password=passwrd, PasswordResetRequired=False)
    iam_re.meta.clientattach_user_policy(UserName=iam_user_name, policyarn=policyarn)
    print(f"IAM User Name: {iam_user_name} and Password={passwrd}")
    return None