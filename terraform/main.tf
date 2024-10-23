module "s3" {
  source = "./modules/s3"

  for_each = var.s3_buckets

  s3_name       = each.key
  s3_is_website = each.value.website
  s3_versioning = each.value.versioning
}

module "dockerized_lambdas" {
  source = "./modules/dockerized_lambdas"

  lambda_role_arn = data.aws_iam_role.lab_role.arn
  lambda_vpc_id   = module.vpc.vpc_id
  lambda_names    = var.dockerized_lambda_names
  lambda_subnets  = module.vpc.private_subnets
  lambda_env_vars = {
    DB_HOST     = module.rds_proxy.proxy_endpoint
    DB_NAME     = var.rds.db_name
    DB_PORT     = var.rds.db_port
    SECRET_NAME = aws_secretsmanager_secret.db_credentials.name
  }
  lambda_aws_account_id = data.aws_caller_identity.current.account_id
  lambda_region_name    = data.aws_region.current.name
}


locals {
  environment_variables = {
    "upload_image" = {
      "BUCKET_NAME" = module.s3["uploaded-images"].bucket_name
    }
  }
}


module "zipped_lambda" {
  source                = "./modules/zipped_lambda"
  for_each              = toset(var.zipped_lambdas)
  lambda_name           = each.key
  environment_variables = local.environment_variables[each.key]
  lambda_role_arn       = data.aws_iam_role.lab_role.arn
  source_code_hash      = data.archive_file.zipped_lambdas[each.key].output_base64sha256
}

resource "aws_vpc_security_group_egress_rule" "lambda_sg_egress" {
  security_group_id            = module.dockerized_lambdas.lambda_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.proxy.id
}

resource "aws_apigatewayv2_api" "main" {
  name          = "sp-api-gw"
  description   = "API Gateway for Soul Pupils"
  protocol_type = "HTTP"

  cors_configuration {
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"]
    allow_headers = ["*"]
    allow_origins = ["*"]
  }
}




locals {
  upload_image_lambda = module.zipped_lambda["upload_image"]
  private_lambdas     = module.dockerized_lambdas.lambdas
  regional_lambdas = {
    (local.upload_image_lambda.function_name) = local.upload_image_lambda
  }

  all_lambdas = merge(local.private_lambdas, local.regional_lambdas)
}

resource "aws_apigatewayv2_integration" "main" {
  for_each           = { for endpoint in var.api_endpoints : endpoint.name => endpoint }
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = local.all_lambdas[each.value.name].invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  for_each      = { for endpoint in var.api_endpoints : endpoint.name => endpoint }
  statement_id  = each.value.name
  action        = "lambda:InvokeFunction"
  function_name = each.value.name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*/${each.value.name}"
  depends_on    = [aws_apigatewayv2_integration.main]

}

resource "aws_apigatewayv2_authorizer" "main" {
  api_id           = aws_apigatewayv2_api.main.id
  name             = "soul-pupils-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.main.id]
    issuer   = "https://${aws_cognito_user_pool.main.endpoint}"
  }
}

resource "aws_apigatewayv2_route" "main" {
  for_each             = { for endpoint in var.api_endpoints : endpoint.name => endpoint }
  api_id               = aws_apigatewayv2_api.main.id
  route_key            = "${each.value.method} ${each.value.path}"
  target               = "integrations/${aws_apigatewayv2_integration.main[each.value.name].id}"
  authorizer_id        = each.value.require_authorization ? aws_apigatewayv2_authorizer.main.id : null
  authorization_type   = each.value.require_authorization ? "JWT" : null
  authorization_scopes = each.value.authorization_scopes
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "dev"
  auto_deploy = true
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_apigatewayv2_route.main]
}
