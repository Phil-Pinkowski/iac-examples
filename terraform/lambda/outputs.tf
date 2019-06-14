output "url" {
  value = "https://${aws_api_gateway_deployment.default.rest_api_id}.execute-api.eu-west-2.amazonaws.com/${aws_api_gateway_deployment.default.stage_name}${aws_api_gateway_resource.hello.path}"
}
