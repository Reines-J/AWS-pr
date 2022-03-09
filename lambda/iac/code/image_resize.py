import boto3
import os
import sys
import uuid
from urllib.parse import unquote_plus
from PIL import Image
import PIL.Image

s3_client = boto3.client('s3')
print(s3_client)
print('==========')

def resize_image(image_path, resized_path):
    with Image.open(image_path) as image:
        image.thumbnail(tuple(x / 2 for x in image.size))
        image.save(resized_path)

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        print(bucket)
        print('==========')
        key = unquote_plus(record['s3']['object']['key'])
        print(key)
        print('==========')
        tmpkey = key.replace('/', '')
        print(tmpkey)
        print('==========')
        download_path = '/tmp/{}{}'.format(uuid.uuid4(), tmpkey)
        print(download_path)
        print('==========')
        upload_path = '/tmp/resized-{}'.format(tmpkey)
        print(upload_path)
        print('==========')
        s3_client.download_file(bucket, key, download_path)
        resize_image(download_path, upload_path)
        s3_client.upload_file(upload_path, bucket, "resize/"+key)
        