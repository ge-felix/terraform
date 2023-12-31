import boto3
import json
import time

def lambda_handler(event, context):
    # Create a DynamoDB resource using the Lambda's execution role
    dynamodb = boto3.resource('dynamodb')
    
    # Get the DynamoDB table
    table_name = "BrowserTimeTable"  
    table = dynamodb.Table(table_name)
    
    # Retrieve input variables from the Lambda event
    body = json.loads(event.get('body', '{}'))
    browser_info = body.get('browser_info', 'Unknown')
    time_accessed = body.get('time_accessed', 'N/A')
    
    # Insert data into the table
    response = table.put_item(
        Item={
            'BrowserInfo': browser_info,
            'TimeAccessed': time_accessed
        }
    )
    
    # Scan the entire table to count the total number of rows
    scan_response = table.scan(Select='COUNT')
    total_rows = scan_response['Count']
    
    # Return the number of records inserted and the total number of rows
    return {
        'statusCode': 200,
        'body': json.dumps({
            'inserted_records': f"Inserted {response['ResponseMetadata']['RequestId']} records.",
            'total_rows': f"{total_rows}"
        })
    }
