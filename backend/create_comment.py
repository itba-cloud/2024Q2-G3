from db import get_session
from models import Comment, User
import json
import uuid
import datetime
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    session = get_session()
    logger.info("Event: %s", event)

    try:
        data = json.loads(event['body'])

        content = data.get('content')
        claims = event['requestContext']['authorizer']['claims']
        email = claims['email']

        publication_id = data.get('publication_id')

        if not content or not email or not publication_id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'content, user_id, and publication_id are required'})
            }
            
        user = session.query(User).filter_by(email=email).first()
        if not user:
            logger.error("User not found")
            return {
                'statusCode': 400,
                'body': 'User not found'
            }
                

        new_comment = Comment(
            comment_id=str(uuid.uuid4()),
            content=content,
            user_id=user.user_id,
            publication_id=publication_id,
            created_at=datetime.datetime.now()
        )
        

        session.add(new_comment)
        session.commit()

        new_comment_id = str(new_comment.comment_id)
        session.close()

        logger.info(f'Comment: {new_comment_id}')

        return {
            'statusCode': 201,
            'body': json.dumps({
                'message': 'Comment created successfully',
                'comment_id': new_comment_id
            })
        }

    except Exception as e:
        session.close()
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
