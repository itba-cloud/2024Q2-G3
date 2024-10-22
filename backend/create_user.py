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
    # logger.info(event)

    try:
        email = event.get('request').get('userAttributes').get('email')
        username = event.get('request').get('userAttributes').get('preferred_username') 
        
        try:
            user = User(
                user_id=str(uuid.uuid4()),
                username=username,
                email=email
            )
            session.add(user)
            session.commit()
        except Exception as e:
            logger.error("Error creating user: there was already a user with the same email")
            return {
                'statusCode': 500,
                'body': 'There was already a user with the same username or email'
            }

        # logger.info(f'User: {user.user_id}')
        session.close()
        return event

    except Exception as e:
        session.close()
        logger.error(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
