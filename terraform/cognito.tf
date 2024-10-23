resource "aws_cognito_user_pool" "main" {
  name = "soul-pupils"

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  auto_verified_attributes = ["email"]

  username_attributes = ["email"]

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }

  schema {
    name                = "preferred_username"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }

  lambda_config {
    post_confirmation = module.dockerized_lambdas.lambdas["create_user"].arn
  }
}

resource "aws_lambda_permission" "allow_cognito_to_invoke" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = module.dockerized_lambdas.lambdas["create_user"].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.main.arn
}

resource "random_id" "cognito" {
  byte_length = 8
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "soul-pupils-app-auth-${random_id.cognito.hex}"
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "main" {
  name                                 = "soul-pupils-client"
  user_pool_id                         = aws_cognito_user_pool.main.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = ["http://localhost:3000"]
  access_token_validity                = 1
  id_token_validity                    = 1
  refresh_token_validity               = 30
}

resource "terraform_data" "cognito_base_url" {
  input = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${data.aws_region.current.name}.amazoncognito.com/"
  triggers_replace = [
    aws_cognito_user_pool_domain.main.domain,
    data.aws_region.current.name
  ]
}
