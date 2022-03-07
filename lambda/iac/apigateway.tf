resource "aws_apigatewayv2_api" "api-lambda" {
  name                       = "api-lambda"
  protocol_type              = "HTTP"
}

resource "aws_apigatewayv2_stage" "stage-l" {
  api_id = aws_apigatewayv2_api.api-lambda.id
  name   = "default"
}

resource "aws_apigatewayv2_integration" "api-lambda" {
  api_id           = aws_apigatewayv2_api.api-lambda.id
  integration_type = "AWS_PROXY"
  connection_type           = "INTERNET"
  description               = "API Lambda Test"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "api-lambda" {
  api_id    = aws_apigatewayv2_api.api-lambda.id
  route_key = "ANY /test/{id}"
  target = "integrations/${aws_apigatewayv2_integration.api-lambda.id}"
}

resource "aws_lambda_permission" "api-lambda" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.api-lambda.execution_arn}/*/*/*"
}
