output "lambda_sg" {
  value = aws_security_group.lambda
}

output "lambdas" {
  value = {
    for lambda in var.lambda_names : lambda => aws_lambda_function.this[lambda]
  }
}

