data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "basic_lambda" {
  filename         = var.lambda_bundle_path
  function_name    = var.lambda_name
  role             = var.lambda_role
  handler          = "lambda.handler"
  runtime          = "nodejs10.x"
  source_code_hash = "${filebase64sha256(var.lambda_bundle_path)}"
  environment {
    variables = {
      TEST = var.test_env
    }
  }
}

resource "aws_lambda_permission" "hello_world" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.basic_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.default.execution_arn}/*/*"
}


resource "aws_api_gateway_resource" "hello" {
  path_part   = var.api_endpoint_path
  parent_id   = var.api_root_id
  rest_api_id = var.api_id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.api_id
  resource_id   = "${aws_api_gateway_resource.hello.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.api_id
  resource_id             = "${aws_api_gateway_resource.hello.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-west-2:lambda:path/2015-03-31/functions/${aws_lambda_function.basic_lambda.arn}/invocations"
  # Need time for the role to propagate in AWS, otherwise
  # it will not be available when the lambda is created
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_api_gateway_deployment" "default" {
  depends_on = [
    "aws_api_gateway_method.method",
    "aws_api_gateway_integration.integration",
  ]
  stage_name  = "dev"
  rest_api_id = var.api_id
}
