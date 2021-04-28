data "aws_caller_identity" "current" {}

data "archive_file" "process_lambda_zip" {
    type        = "zip"
    source_dir  = "${path.module}/../../../code/processor"
    output_path = "${path.module}/process_lambda.zip"
}

data "archive_file" "api_lambda_zip" {
    type        = "zip"
    source_dir  = "${path.module}/../../../code/api"
    output_path = "${path.module}/api_lambda.zip"
}

########################## FILE PROCESS LAMBDA ######################
resource "aws_lambda_function" "assignment_file_processing_lambda" {
  filename      = "${path.module}/process_lambda.zip"
  function_name = "file_processing_function"
  role          = var.lambda_role
  handler       = "lambda_function.lambda_handler"
  timeout       = 360
  runtime       = "python3.8"
}

resource "aws_s3_bucket_notification" "my-trigger" {
    bucket = var.bucket

    lambda_function {
      lambda_function_arn = aws_lambda_function.assignment_file_processing_lambda.arn
      events              = ["s3:ObjectCreated:*"]
    }
}

resource "aws_lambda_permission" "lambda_s3_invoke_permission" {
  statement_id  = "AllowS3CopyInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.assignment_file_processing_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket}"
}

############################ API LAMBDA #############################
resource "aws_lambda_function" "assignment_api_lambda" {
  filename      = "${path.module}/api_lambda.zip"
  function_name = "api_function"
  role          = var.lambda_role
  handler       = "lambda_function.lambda_handler"
  timeout       = 360
  runtime       = "python3.8"
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.assignment_api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${var.rest_api_id}/*/*"
}

#######################################################################################################