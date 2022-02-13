import boto3
import json
import time

kinesis =  boto3.client('kinesis', region_name='ap-northeast-2')
shard_list = [shard['ShardId'] for shard in kinesis.describe_stream(StreamName='test')['StreamDescription']['Shards']]
num_list = [shard['SequenceNumberRange']["StartingSequenceNumber"] for shard in kinesis.describe_stream(StreamName='test')['StreamDescription']['Shards']]
#print(json.dumps(kinesis.describe_stream(StreamName='test'), indent = 2, sort_keys = True, default= str))
print(shard_list)
print(num_list)
first_shard = shard_list[0]
first_num =num_list[0]
iterator = kinesis.get_shard_iterator(
    StreamName = "test", 
    ShardId = first_shard, 
    ShardIteratorType = "AT_SEQUENCE_NUMBER",
    StartingSequenceNumber = first_num
)['ShardIterator']

#records = kinesis.get_records(ShardIterator=iterator)
#print(json.dumps(records, indent=2, sort_keys=True, default=str))

while True:
    with open("test.json", 'a') as test:
        records = kinesis.get_records(ShardIterator=iterator)["Records"]
        if len(records):
            for data in records:
                test.write(f"{data['Data'].decode('utf-8')}\n")
        iterator = kinesis.get_records(ShardIterator=iterator)['NextShardIterator']
        time.sleep(1)