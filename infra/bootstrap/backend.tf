terraform {
  # The bucket name comes from ../backend.hcl (gitignored, see ../backend.hcl.example):
  #   terraform init -backend-config=../backend.hcl
  backend "s3" {
    key          = "bootstrap/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}