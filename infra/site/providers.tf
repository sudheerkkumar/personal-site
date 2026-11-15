terraform {
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

locals {
  account_id = var.account_id
  domain     = "sudheerkancharla.dev"

  tags = {
    project    = "personal-site"
    managed-by = "terraform"
    stack      = "site"
  }
}

# Default provider: the project's region (Stockholm)
provider "aws" {
  region              = "eu-north-1"
  allowed_account_ids = [local.account_id]
  default_tags { tags = local.tags }
}

# Second provider for us-east-1: CloudFront only accepts certificates from there
provider "aws" {
  alias               = "us_east_1"
  region              = "us-east-1"
  allowed_account_ids = [local.account_id]
  default_tags { tags = local.tags }
}