import json
import base64
import boto3
import uuid
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket_name = os.environ.get('BUCKET_NAME')
    
    try:
        body = json.loads(event['body'])
        image_data = body['image_data']
        file_type = body.get('file_type', 'jpeg')

        if file_type not in ['jpg', 'jpeg', 'png', 'gif']:
            return {
                'statusCode': 400,
                'body': json.dumps('Invalid file type. Only "jpeg", "png" and "gif" are allowed.')
            }
        
        if len(image_data) > 20 * 1024 * 1024:
            return {
                'statusCode': 400,
                'body': json.dumps('Image size exceeds the limit of 20MB.')
            }

    except KeyError:
        return {
            'statusCode': 400,
            'body': json.dumps('Invalid input. Make sure to provide "image_data" and optionally "file_type".')
        }

    file_name = f"{uuid.uuid4()}.{file_type}"
    
    try:
        image_bytes = base64.b64decode(image_data)
    except base64.binascii.Error as e:
        return {
            'statusCode': 400,
            'body': json.dumps('Error decoding base64 image data.')
        }
    
    try:
        s3.put_object(
            Bucket=bucket_name,
            Key=file_name,
            Body=image_bytes,
            ContentType=f'image/{file_type}'
        )
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f"Failed to upload image to S3: {str(e)}")
        }
    
    # Return the S3 object URL
    s3_url = f"https://{bucket_name}.s3.amazonaws.com/{file_name}"
    
    return {
        'statusCode': 200,
        'body': json.dumps({'url': s3_url})
    }