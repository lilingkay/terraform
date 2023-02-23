terraform {
    required_version = ">=1.0"

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
<<<<<<< HEAD
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
=======
>>>>>>> d15b7d7ea4f6529d7f4402cb950ee0f82c81aee6
}

