output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "frontend_endpoint" {
  value = var.s3_is_website ? aws_s3_bucket_website_configuration.this[0].website_endpoint : null
}
