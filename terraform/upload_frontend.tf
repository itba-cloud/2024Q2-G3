resource "terraform_data" "upload_build" {

  provisioner "local-exec" {
    command = "${path.cwd}/scripts/deploy_frontend.sh ${module.s3["soul-pupils-spa"].bucket_name} ${aws_apigatewayv2_api.main.api_endpoint}/${aws_apigatewayv2_stage.main.name} ${aws_cognito_user_pool.main.id} ${aws_cognito_user_pool_client.main.id} ${terraform_data.cognito_base_url.output} ${data.aws_region.current.name}"
  }

  triggers_replace = {
    always_run = "${timestamp()}"
  }
}
