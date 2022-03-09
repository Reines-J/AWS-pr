import json

def lambda_handler(event, context):
    print(event)
    return{
        "statusCode": 200,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": json.dumps({
            "id": event["pathParameters"]["id"],
            "method": event["requestContext"]["http"]["method"],
            "protocol": event["requestContext"]["http"]["protocol"]
        })
    }
    