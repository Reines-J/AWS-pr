resource "aws_cloudwatch_event_rule" "ec2-stop" {
    name = "ec2-stop"
    description = "Ec2 stop satatus change start"
    event_bus_name = "default"
    event_pattern = <<EOF
{
    "source": [
        "aws.ec2"
    ],
    "detail-type": [
        "EC2 Instance State-change Notification"
    ],
    "detail":{
        "state": ["stopped"]
    }
}
    EOF
}

resource "aws_lambda_permission" "EB-lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2-stop.arn
}

resource "aws_cloudwatch_event_target" "EB-lambda" {
  arn  = aws_lambda_function.test_lambda.arn
  rule = aws_cloudwatch_event_rule.ec2-stop.id
}