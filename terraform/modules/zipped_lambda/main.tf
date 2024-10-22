resource "terraform_data" "zip_lambda" {
  provisioner "local-exec" {
    command = "zip -j ${path.cwd}/lambda_${var.lambda_name}.zip ${path.cwd}/../backend/${var.lambda_name}.py"
  }
  triggers_replace = {
    always_run = "${timestamp()}"
  }
}

resource "aws_lambda_function" "this" {

  function_name    = var.lambda_name
  timeout          = 60
  filename         = "${path.cwd}/lambda_${var.lambda_name}.zip"
  handler          = "${var.lambda_name}.lambda_handler"
  source_code_hash = var.source_code_hash
  runtime          = "python3.11"
  architectures    = ["x86_64"]
  role             = var.lambda_role_arn

  environment {
    variables = var.environment_variables
  }
  depends_on = [terraform_data.zip_lambda]
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
