resource "aws_s3_bucket" "s3-lambda" {
  bucket = "lambda-rtest-bucket"
}

resource "aws_lambda_permission" "s3-lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3-lambda.arn
}

resource "aws_s3_bucket_notification" "s3-lambda" {
  bucket = aws_s3_bucket.s3-lambda.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "images-"
    filter_suffix       = ""
  }
  depends_on = [aws_lambda_permission.s3-lambda]
}
