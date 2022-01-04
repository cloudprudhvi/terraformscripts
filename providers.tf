terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
  provider "aws" {
    region = "us-west-2"
  }
terraform {
  backend "s3" {
    bucket = "terraform488"
    key    = "dev/terraform.tfstate"
    region = "us-west-2"
  }
}

