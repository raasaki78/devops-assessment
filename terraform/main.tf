provider "aws" {
  profile = var.profile
  region = var.region
}

module "s3" {
  source = "./modules/s3"
  bucket_name = "devops-assignment-storage-bucket"
  glacier_vault_name = "devops-assignment-vault1-storage"
}

module "iam" {
  source = "./modules/iam"
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = "devops-assignment"
  primary_key = "Timestamp"
}

module "api" {
  source = "./modules/api-gateway"
  cloudwatch_role = module.iam.apig_role
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}

module "lambda" {
  source      = "./modules/lambda"
  lambda_role = module.iam.lambda_role
  bucket      = module.s3.bucket_name
  region      = var.region
  rest_api_id = module.api.api_id
}