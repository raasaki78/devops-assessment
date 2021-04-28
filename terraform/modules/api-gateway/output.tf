output "api_endpoint" {
  value = aws_api_gateway_deployment.assignment_api_deployment.invoke_url
}

output "api_id" {
  value = aws_api_gateway_rest_api.assignment_api.id
}