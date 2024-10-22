resource "aws_db_subnet_group" "db" {
  name       = "db_subnet_group"
  subnet_ids = module.vpc.database_subnets
}

resource "aws_db_instance" "main" {
  allocated_storage      = 20
  db_name                = var.rds.db_name
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t4g.micro"
  username               = var.rds.db_username
  password               = var.rds.db_password
  availability_zone      = "us-east-1a"
  multi_az               = false
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot    = true
  tags = {
    Name = "bd-sql"
  }
}

module "rds_proxy" {
  source = "./modules/rds-proxy"

  name                   = "bd-sql-proxy"
  create_iam_role        = false
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.proxy.id]
  role_arn               = data.aws_iam_role.lab_role.arn
  require_tls            = false
  auth = {
    (var.rds.db_username) = {
      description = aws_secretsmanager_secret.db_credentials.description
      secret_arn  = aws_secretsmanager_secret.db_credentials.arn
    }
  }

  engine_family = "POSTGRESQL"
  debug_logging = true

  target_db_instance     = true
  db_instance_identifier = aws_db_instance.main.identifier
}
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "db_credentials9"
  description = "RDS database credentials"
}


resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.rds.db_username
    password = var.rds.db_password
  })
}

resource "aws_security_group" "db" {
  vpc_id = module.vpc.vpc_id
  name   = "bd_sg"
}

resource "aws_security_group" "proxy" {
  vpc_id = module.vpc.vpc_id
  name   = "proxy_sg"
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  security_group_id            = aws_security_group.db.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.proxy.id
}

resource "aws_vpc_security_group_ingress_rule" "proxy" {
  security_group_id            = aws_security_group.proxy.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.dockerized_lambdas.lambda_sg.id
}

resource "aws_vpc_security_group_egress_rule" "proxy" {
  security_group_id            = aws_security_group.proxy.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.db.id
}
