data "aws_iam_policy_document" "lamlog-s3"{
    source_json = "${file("policy/lambda-s3.json")}"
}

data "aws_iam_policy_document" "lamlog"{
    source_json = "${file("policy/lambda.json")}"
}

data "aws_iam_policy_document" "lambda-a"{
    source_json = "${file("policy/assume-lambda.json")}"
}

resource "aws_iam_role" "TestLambda" {
  name = "TestLambda"
  assume_role_policy = data.aws_iam_policy_document.lambda-a.json
}

resource "aws_iam_role_policy" "TestLambda" {
  name = "TestLambda"
  role = aws_iam_role.TestLambda.id
  policy = data.aws_iam_policy_document.lamlog.json
  #policy = data.aws_iam_policy_document.lamlog-s3.json
}
