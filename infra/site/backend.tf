terraform {
  backend "s3" {
    bucket       = "sudheerkancharla-tfstate-<account-id>"
    key          = "site/terraform.tfstate"   # separate state file from bootstrap
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}