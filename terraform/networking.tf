locals {
  cidrs                 = cidrsubnets(var.vpc.vpc_cidr, 8, 8, 8, 8)
  private_subnet_cidrs  = slice(local.cidrs, 0, 2)
  database_subnet_cidrs = slice(local.cidrs, 2, 4)
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc.vpc_name
  cidr = var.vpc.vpc_cidr

  azs                   = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets       = local.private_subnet_cidrs
  database_subnets      = local.database_subnet_cidrs
  private_subnet_names  = var.vpc.private_subnet_names
  database_subnet_names = var.vpc.database_subnet_names
}
