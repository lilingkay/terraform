terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.57.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
  access_key = "AKIAYUVEAJVQ7PLPCDPU"
  secret_key = "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"
}
