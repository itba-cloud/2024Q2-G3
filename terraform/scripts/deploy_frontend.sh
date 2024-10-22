#!/bin/bash
bucket_name=$1
backend_url=$2
client_id=$3
cognito_url=$4
redirect_url=$5
cd ./../frontend
echo PUBLIC_BASE_PATH=$backend_url > .env
echo PUBLIC_COGNITO_APP_CLIENT_ID=$client_id >> .env
echo PUBLIC_COGNITO_URL=$cognito_url >> .env
echo PUBLIC_REDIRECT_URL=$redirect_url >> .env
npm install
npm run build
aws s3 cp build s3://$1 --recursive