output "lambda_invoke_arn" {
  value = aws_lambda_function.assignment_api_lambda.invoke_arn 
}