terraform {
  backend "s3" {
    bucket       = "sudheerkancharla-tfstate-<account-id>"
    key          = "bootstrap/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}