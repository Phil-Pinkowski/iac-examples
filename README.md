# Infrastructure as Code Examples

## Terraform Example

This is a basic example of a simple Terraform infrastructure setup with a couple of lambda functions and API Gateway endpoints. The state is stored locally for this example, but for a more realistic setup we should have a shared state, stored somewhere like S3.

### Setup

This requires npm (Node JS) and [Terraform](https://www.terraform.io/downloads.html) to be installed.

### Deploy

To deploy the lambdas, run `npm run deploy`. This will initialise the terraform installation and deploy the resources to the AWS environment linked to the current logged in AWS account. Before you do this you must have configured your AWS CLI credentials (using `aws configure`)

### Removing

To remove the deployed resources, run `npm run remove`. This will destroy the deployed terraform resources and remove them from AWS.

## Serverless Example

This is a similar setup to the Terraform example - we are deploying two lambdas from the same code origin with some environment variables set, and mapped to API Gateway endpoints.

### Setup

Serverless must be installed. Run `npm i -g serverless` to install the CLI tool.

### Deploy

To deploy the lambdas, run `serverless deploy`. The serverless tool will zip the code and deploy a CloudFormation stack.

### Removing

To remove the stack and the lambdas, run `serverless remove`