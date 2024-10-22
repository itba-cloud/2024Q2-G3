variable "vpc" {
  type = object({
    vpc_cidr              = string
    vpc_name              = string
    private_subnet_names  = list(string)
    database_subnet_names = list(string)
  })
}

variable "s3_buckets" {
  type = map(object({
    website    = bool
    versioning = bool
  }))
}

variable "rds" {
  type = object({
    db_name     = string
    db_username = string
    db_password = string
    db_port     = number
  })
}

variable "dockerized_lambda_names" {
  type = list(string)
}

variable "zipped_lambdas" {
  type = list(string)
}

variable "api_endpoints" {
  type = list(object({
    name                  = string
    method                = string
    path                  = string
    require_authorization = bool
    authorization_scopes  = list(string)
  }))
}
