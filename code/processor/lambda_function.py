import json
import urllib.parse
import boto3
import csv

def lambda_handler(event, context):
    
    glacierVaultName = "devops-assignment-vault-storage"
    tableName = "devops-assignment"
    reg_name = "us-east-1"
    
    s3 = boto3.client('s3')
    dynamodb = boto3.client('dynamodb', region_name=reg_name)
    glacier_client = boto3.client('glacier')
    
    print("Received event: " + json.dumps(event, indent=2))
    # Get object details from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
        
    try:
    
        # get the csv file from s3 for which event was triggered
        response = s3.get_object(Bucket=bucket, Key=key)

        # deserialize data & split on lines
        csv_lines_list = response["Body"].read().decode('utf-8').split("\n")
    
        # convert to list of lists
        csv_lines_list = list(csv.reader(csv_lines_list, delimiter=',', quotechar='"'))
        

        # grab the keys from first line of csv file
        key_list = csv_lines_list[0]
        key_dict = {}
        
        # note the position of each key
        count = 0
        for ind_key in csv_lines_list[0]:
            key_dict[str(ind_key)] = count
            count += 1
    
        # parse the csv data depending on keys
        if len(csv_lines_list) > 0:
            for line in csv_lines_list[1:]:
                rtype = line[key_dict["Type"]]
                value = line[key_dict["Value"]]
                timestamp = line[key_dict["Timestamp"]]
                
                # add data to dynamoDB table
                add_to_db = dynamodb.put_item(
                    TableName = tableName,
                    Item = {
                        "Timestamp" : {"S": str(timestamp)},
                        "Type" : {"S": str(rtype)},
                        "Value" : {"N": str(value)}
                    })
                    
                print("Successfully added recored to DynamoDB!!!")
        
        # get data for archival
        archival_data = s3.get_object(Bucket=bucket, Key=key)

        # archive the file on S3 to glacier
        archive_resp = glacier_client.upload_archive(vaultName=glacierVaultName,body=archival_data["Body"].read())
        print("Successfully archived file!!!")
        print(archive_resp)
        
        # delete file from s3
        delete_resp = s3.delete_object(Bucket=bucket,Key=key)
        print("Successfully deleted file from S3!!!")
        print(delete_resp)

    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
        
    return {
        'statusCode': 200,
        'body': json.dumps('Successfully processed file!!!')
    }