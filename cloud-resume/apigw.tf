resource "aws_apigatewayv2_api" "myapi" {
  name          = "myapi"
  protocol_type = "HTTP"
  	cors_configuration {
		allow_origins = ["*"]
        allow_methods = ["POST"]
        allow_headers = ["Content-Type"]
	}
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.myapi.id
  integration_type = "AWS_PROXY"

  description = "Lambda integration"

  integration_method = "POST"
  integration_uri    = aws_lambda_function.lambda_dbquery.invoke_arn
}

resource "aws_apigatewayv2_route" "myapi_route" {
  api_id    = aws_apigatewayv2_api.myapi.id
  route_key = "POST /execute"

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_deployment" "myapi_deployment" {
  api_id      = aws_apigatewayv2_api.myapi.id
  description = "myapi deployment"
  #Trigger an auto deploy https://github.com/hashicorp/terraform-provider-aws/issues/162#issuecomment-532593939
  #triggers = {
    #redeployment = sha1(jsonencode([
    #  aws_apigatewayv2_api.myapi,
    #  aws_apigatewayv2_integration.lambda_integration,
    #  aws_apigatewayv2_route.myapi_route,
    #]))
  #}

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_apigatewayv2_route.myapi_route
  ]
}

resource "aws_apigatewayv2_stage" "myapi_stage" {
  api_id = aws_apigatewayv2_api.myapi.id
  name   = "myapi-stage"
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_dbquery.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.myapi.execution_arn}/*/*"
}
