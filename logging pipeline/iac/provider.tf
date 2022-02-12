provider "aws" {
  region  = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket         = "s3-${var.resource_tag}"
    key            = "terraform/terraform.tfstate"
    region         = "ap-northeast-2"
  }
}
