########### Cloudwatch role for api gateway #############################
resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  name = "api_gateway_datalake_cloudwatch_role"
  assume_role_policy = file("${path.module}/policies/cloudwatch_role_trust_policy.json")
}

################## Cloudwatch policy ##################################
resource "aws_iam_role_policy" "cloudwatch_policy" {
  name    = "datalake_cloudwatch_policy"
  role    = aws_iam_role.api_gateway_cloudwatch_role.id
  policy  = file("${path.module}/policies/cloudwatch_policy.json")
}

################## Lambda Role ###############################
# Lambda IAM role
resource "aws_iam_role" "lambda_role" {
  name = "assignment_lambda_rolerequestrate"
  path = "/"
  assume_role_policy = file("${path.module}/policies/lambda_trust_policy.json")
}

############# Attach cloudwatch access to Lambda ############################
resource "aws_iam_policy" "lambda_policy" {
  name        = "assignment_lambda_cloudwatch_policyrequestrate"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = file("${path.module}/policies/lambda_policy.json")
}

################## Policy attachment for lambda role #########################
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}