terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "4.67.0"
      version = ">= 4.0, <5.0"
    }
  }

  backend "s3" {
    bucket = "tfstate-actions"
    key = "github-actions"
    region = "eu-west-1"
    encrypt = true
  }
}
