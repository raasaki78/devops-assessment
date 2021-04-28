################ CREATE API #########################
resource "aws_api_gateway_rest_api" "assignment_api" {
  name                      = var.api_name
  description               = "Restful API for assignment Assignment"
}

################## STAGE #######################
resource "aws_api_gateway_stage" "stage" {
  stage_name            = "dev"
  rest_api_id           = aws_api_gateway_rest_api.assignment_api.id
  deployment_id         = aws_api_gateway_deployment.assignment_api_deployment.id
}

################### DEPLOYMENT #############################
resource "aws_api_gateway_deployment" "assignment_api_deployment" {
  depends_on = [
      aws_api_gateway_integration.currentinterestrate_get_integration,
    ]

  rest_api_id = aws_api_gateway_rest_api.assignment_api.id
  
  triggers={
        build_number = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

################ Enable cloudwatch logging ##########################
resource "aws_api_gateway_account" "api_logging" {
  cloudwatch_role_arn = var.cloudwatch_role
}

################ Common Method Settings ##############################
resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = aws_api_gateway_rest_api.assignment_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled        = true
    data_trace_enabled     = true
    logging_level          = var.logging_level
    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = var.throttling_rate_limit
    throttling_burst_limit = var.throttling_burst_limit
  }
}
