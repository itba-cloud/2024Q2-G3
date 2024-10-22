from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.sql import text
import os
import json
import boto3

DB_HOST = os.getenv('DB_HOST')
DB_NAME = os.getenv('DB_NAME')
DB_PORT = os.getenv('DB_PORT', '5432')
SECRET_NAME = os.getenv('SECRET_NAME')

def get_url():
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager')
    get_secret_value_response = client.get_secret_value(SecretId=SECRET_NAME)
    secret = json.loads(get_secret_value_response['SecretString'])

    URL = f"postgresql://{secret['username']}:{secret['password']}@{DB_HOST}:{DB_PORT}"

    return URL

def get_session():
    url = get_url()
    engine = create_engine(f"{url}/{DB_NAME}")
    Session = sessionmaker(bind=engine)
    return Session()

def create_database():
    url = get_url()
    root_session = sessionmaker(bind=create_engine(f"{url}/postgres"))()

    root_session.execute(text("commit"))
    root_session.execute(text(f"DROP DATABASE IF EXISTS {DB_NAME}"))
    root_session.execute(text(f"CREATE DATABASE {DB_NAME}"))
    root_session.close()
    session = get_session()
    return session