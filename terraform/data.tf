data "aws_canonical_user_id" "current" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "archive_file" "zipped_lambdas" {
  for_each = toset(var.zipped_lambdas)

  type        = "zip"
  source_file = "${path.cwd}/../backend/${each.key}.py"
  output_path = "${path.cwd}/lambda_${each.key}.zip"
}
