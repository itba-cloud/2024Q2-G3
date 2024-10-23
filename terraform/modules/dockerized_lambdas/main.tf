resource "aws_ecr_repository" "this" {
  for_each = toset(var.lambda_names)

  name = each.key

  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_lambda_function" "this" {
  for_each = toset(var.lambda_names)

  function_name = each.key
  timeout       = 60
  image_uri     = "${aws_ecr_repository.this[each.key].repository_url}:latest"
  package_type  = "Image"
  architectures = ["x86_64"]
  vpc_config {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids         = var.lambda_subnets
  }
  environment {
    variables = var.lambda_env_vars
  }
  role       = var.lambda_role_arn
  depends_on = [terraform_data.deploy_images]

}

resource "terraform_data" "deploy_images" {

  provisioner "local-exec" {
    working_dir = "${path.cwd}/scripts"
    command     = "${path.cwd}/scripts/deploy_all.sh ${var.lambda_aws_account_id}"
  }
  triggers_replace = {
    always_run = "${timestamp()}"
  }
  depends_on = [aws_ecr_repository.this]

}

resource "aws_security_group" "lambda" {
  vpc_id = var.lambda_vpc_id
  name   = var.lambda_security_group_name
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_endpoint" {
  vpc_id = var.lambda_vpc_id
  name   = var.lambda_vpc_endpoint_sg_name
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda.id]
  }
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda.id]
  }
}

resource "aws_vpc_security_group_ingress_rule" "lambda_vpc_endpoint" {
  security_group_id            = aws_security_group.lambda.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.vpc_endpoint.id
}

resource "aws_vpc_security_group_egress_rule" "lambda_vpc_endpoint" {
  security_group_id            = aws_security_group.lambda.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.vpc_endpoint.id
}


resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id              = var.lambda_vpc_id
  service_name        = "com.amazonaws.${var.lambda_region_name}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = var.lambda_subnets
  private_dns_enabled = true
}

