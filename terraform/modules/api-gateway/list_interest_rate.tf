################## /listinterestrate  ###################################
resource "aws_api_gateway_resource" "listinterestrate" {
  rest_api_id = aws_api_gateway_rest_api.assignment_api.id
  parent_id   = aws_api_gateway_rest_api.assignment_api.root_resource_id
  path_part   = "listinterestrate"
} 

resource "aws_api_gateway_method" "listinterestrate_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.assignment_api.id
  resource_id   = aws_api_gateway_resource.listinterestrate.id
  authorization = "NONE"
  http_method   = "GET"
}

resource "aws_api_gateway_integration" "listinterestrate_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.assignment_api.id
  resource_id             = aws_api_gateway_resource.listinterestrate.id
  http_method             = aws_api_gateway_method.listinterestrate_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

##### CORS CONFIG ####
resource "aws_api_gateway_method" "listinterestrate_CORS" {
  rest_api_id   = aws_api_gateway_rest_api.assignment_api.id
  resource_id   = aws_api_gateway_resource.listinterestrate.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# aws_api_gateway_integration._
resource "aws_api_gateway_integration" "listinterestrate_CORS_Integration" {
  rest_api_id   = aws_api_gateway_rest_api.assignment_api.id
  resource_id   = aws_api_gateway_resource.listinterestrate.id
  http_method   = aws_api_gateway_method.listinterestrate_CORS.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

# aws_api_gateway_integration_response._
resource "aws_api_gateway_integration_response" "listinterestrate_CORS_Integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.assignment_api.id
  resource_id   = aws_api_gateway_resource.listinterestrate.id
  http_method   = aws_api_gateway_method.listinterestrate_CORS.http_method
  status_code   = 200

  response_parameters = local.integration_response_parameters
  
  response_templates = {
    "application/json" = <<EOF
  EOF
  }

  depends_on = [
    aws_api_gateway_integration.listinterestrate_CORS_Integration,
    aws_api_gateway_method_response.listinterestrate_CORS_Method_response,
  ]
}

# aws_api_gateway_method_response._
resource "aws_api_gateway_method_response" "listinterestrate_CORS_Method_response" {
  rest_api_id   = aws_api_gateway_rest_api.assignment_api.id
  resource_id   = aws_api_gateway_resource.listinterestrate.id
  http_method   = aws_api_gateway_method.listinterestrate_CORS.http_method
  status_code   = 200

  response_parameters = local.method_response_parameters

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method.listinterestrate_CORS
  ]
}