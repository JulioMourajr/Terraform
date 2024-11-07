terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.74.0"
    }
  }
  backend "s3" {
    bucket = "ada-s3-julio"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      projeto = "Terraform"
      dono    = "Equipe DevOps - Julio"
    }
  }
}

