import os

def lambda_handler(event, context):
    print(event)
    print(event.get('rawQueryString', ''))
    return {
        'statusCode': '302',
        'headers': {
            'Location': f"http://{os.getenv('FRONTEND_URL')}/callback?{event.get('rawQueryString', '')}"
        },
    }
