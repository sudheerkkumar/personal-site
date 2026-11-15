# --- Terraform and provider versions -------------------------------------
terraform {
  required_version = ">= 1.11"      # needed for S3 native state locking

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"            # any 6.x version, never a surprise 7.0
    }
  }
}

# --- AWS connection -------------------------------------------------------
provider "aws" {
  region = "eu-north-1"

  # Safety net: Terraform refuses to run against any other account,
  # even if the wrong AWS profile is active.
  allowed_account_ids = [var.account_id]

  # Every resource gets these labels automatically
  default_tags {
    tags = {
      project    = "personal-site"
      managed-by = "terraform"
      stack      = "bootstrap"
    }
  }
}

# --- The state bucket -----------------------------------------------------
resource "aws_s3_bucket" "tfstate" {
  bucket = "sudheerkancharla-tfstate-${var.account_id}"   # must be globally unique

  lifecycle {
    prevent_destroy = true   # Terraform refuses to delete this bucket
  }
}

# Keep old versions of the state file, so a broken state can be restored
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt everything stored in the bucket (free, AWS-managed keys)
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block every form of public access
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Reject any request that doesn't use HTTPS
resource "aws_s3_bucket_policy" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "DenyInsecureTransport"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource  = [aws_s3_bucket.tfstate.arn, "${aws_s3_bucket.tfstate.arn}/*"]
      Condition = { Bool = { "aws:SecureTransport" = "false" } }
    }]
  })
  depends_on = [aws_s3_bucket_public_access_block.tfstate]
}

# Delete old state versions after 90 days, so the bucket doesn't grow forever
resource "aws_s3_bucket_lifecycle_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    id     = "expire-old-versions"
    status = "Enabled"
    filter {}
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
  depends_on = [aws_s3_bucket_versioning.tfstate]
}