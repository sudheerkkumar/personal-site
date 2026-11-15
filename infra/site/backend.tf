terraform {
  # The bucket name comes from ../backend.hcl (gitignored, see ../backend.hcl.example):
  #   terraform init -backend-config=../backend.hcl
  backend "s3" {
    key          = "site/terraform.tfstate"   # separate state file from bootstrap
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}