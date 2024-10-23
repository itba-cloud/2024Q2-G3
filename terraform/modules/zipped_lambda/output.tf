output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "function_url" {
  value = aws_lambda_function_url.this.function_url
}

output "invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}
