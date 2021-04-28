output "apig_role" {
  value = aws_iam_role.api_gateway_cloudwatch_role.arn
}

output "lambda_role" {
  value = aws_iam_role.lambda_role.arn
}