provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "eu-west-1"
}

resource "aws_iam_role" "lambda_iam" {
  name               = "lambda_iam"
  assume_role_policy = <<EOF
{
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
  EOF
  # Need time for the role to propagate in AWS, otherwise
  # it will not be available when the lambda is created
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name = "testApi"
}

module "basic_lamda" {
  source = "./lambda"
  lambda_name = "basic-lambda"
  lambda_bundle_path = "build/lambda.zip"
  lambda_role = "${aws_iam_role.lambda_iam.arn}"
  api_id = "${aws_api_gateway_rest_api.api.id}"
  api_root_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  api_endpoint_path = "hello"
  test_env = "World"
}

module "another_lambda" {
  source = "./lambda"
  lambda_name = "another-basic-lambda"
  lambda_bundle_path = "build/lambda.zip"
  lambda_role = "${aws_iam_role.lambda_iam.arn}"
  api_id = "${aws_api_gateway_rest_api.api.id}"
  api_root_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  api_endpoint_path = "hi"
  test_env = "There"
}

