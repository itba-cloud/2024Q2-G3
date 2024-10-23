from db import get_session
from models import Publication, User
import json
import uuid
import datetime
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    session = get_session()
    logger.info(event)

    try:
        data = json.loads(event.get('body'))
        title = data.get('title')
        content = data.get('content')
        claims = event['requestContext']['authorizer']['claims']
        email = claims['email']

        if not title or not content or not email:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'title, content are required'})
            }

        user = session.query(User).filter_by(email=email).first()
        if not user:
            logger.error("User not found")
            return {
                'statusCode': 400,
                'body': 'User not found'
            }

        logger.info(f'User: {user.user_id}')

        new_publication = Publication(
            publication_id=str(uuid.uuid4()), 
            title=title,
            content=content,
            user_id=user.user_id,
            created_at=datetime.datetime.now()
        )

        logger.info(f'Publication: {new_publication.publication_id}')
        session.add(new_publication)
        session.commit()

        publication_id = str(new_publication.publication_id)

        session.close()

        return {
            'statusCode': 201,
            'body': json.dumps({
                'message': 'Publication created successfully',
                'publication_id': publication_id
            })
        }

    except Exception as e:
        session.close()
        logger.error(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
