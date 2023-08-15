terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.0"
    }
  }

  backend "s3" {
    bucket = "tfstate-actions"
    key = "github-actions"
    # region = "eu-west-1"
    encrypt = true
  }
}
