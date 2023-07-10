
# Create the API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.env-name}-api"
  description = "API GATEWAY"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = {
    name = "${var.env-name}-api"
  }
}

#vpc-link
resource "aws_api_gateway_vpc_link" "vpclink" {
  name        = "vpclink"
  description = "linking vpc in api gateway"
  target_arns = [var.lb_arn]
}

# Create a root resource
resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}



# Create a GET method on the root resource
resource "aws_api_gateway_method" "root_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Create an integration for the GET method
resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.root_resource.id
  http_method             = aws_api_gateway_method.root_method.http_method
  # 
  integration_http_method = "ANY"
  # 
  type                    = "HTTP_PROXY"
  # http://35.176.214.118/{proxy}
  uri                     = ""
  

  request_parameters =  {
  "integration.request.path.proxy" = "method.request.path.proxy"
  }

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.vpclink.id


}

# Create a deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.root_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  # stage_name  = "prod"
}

#Enable Xray tracing 
resource "aws_api_gateway_stage" "prod" {
  xray_tracing_enabled = true 
  stage_name = "prod-api"
  rest_api_id = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  access_log_settings {
    format = "$context.requestId"
    destination_arn = aws_cloudwatch_log_group.prod-api.arn
  }
  depends_on = [
    aws_cloudwatch_log_group.prod-api
  ]
}

#Enable cloudwatch logs for the API Gateway

resource "aws_cloudwatch_log_group" "prod-api" {
  name = "${var.env-name}-invest-api-cw-log-group"

  tags = {
    Environment = "prod"
    Application = "${var.env-name}-api"
  }
}

resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "api_gateway_cloudwatch_global"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "cloudwatch" {
  name   = "default"
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}

#Client Certificate
resource "aws_api_gateway_client_certificate" "prod-client-certificate" {
  description = "${var.env-name}-invest-api-client-certificate"
}



# Output the API Gateway URL
output "api_gateway_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}
