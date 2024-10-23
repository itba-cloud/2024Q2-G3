variable "lambda_names" {
  type = list(string)
}

variable "lambda_subnets" {
  type = list(string)
}

variable "lambda_env_vars" {
  type = object({
    DB_HOST     = string
    DB_NAME     = string
    DB_PORT     = string
    SECRET_NAME = string
  })
}

variable "lambda_vpc_id" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "lambda_aws_account_id" {
  type = string
}

variable "lambda_region_name" {
  type = string
}

variable "lambda_security_group_name" {
  type    = string
  default = "lambda_sg"
}

variable "lambda_vpc_endpoint_sg_name" {
  type    = string
  default = "vpc_endpoint_sg"
}
