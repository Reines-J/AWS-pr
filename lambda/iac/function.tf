resource "aws_lambda_function" "test_lambda" {
  filename      = "python/image_resize.zip"
  function_name = "test_lambda"
  role          = aws_iam_role.TestLambda.arn
  handler = "test"
  source_code_hash = filebase64sha256("python/image_resize.zip")
  layers = [aws_lambda_layer_version.PIL.arn]
  memory_size = 1024
  timeout = 60
  package_type = "Zip"
  runtime = "python3.9"
  environment {
    variables = {
      env = "Test"
    }
  }
  tags = {
      tag = "Test"
  }
}

resource "aws_lambda_layer_version" "PIL" {
  filename = "python/PIL.zip"
  source_code_hash = filebase64sha256("python/PIL.zip")
  layer_name = "PIL"
  compatible_runtimes = ["python3.9"]
}