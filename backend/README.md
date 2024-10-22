# Commands 

### Developed with Python 3.11 and AWS Lambda 

## Test locally:
```bash
docker compose up --watch
```

## Deploy all lambdas (docker)
```bash
./deploy_all.sh [aws_id]
```

## Deploy a single lambda (docker)
```bash
./deploy.sh [lambda_name] [aws_id]
```

## Deploy `upload_image` lambda
Just copy the code into the AWS Lambda IDE and set the `BUCKET_NAME` environment variable.