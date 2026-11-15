# infra

Terraform for hosting [sudheerkancharla.dev](https://sudheerkancharla.dev) on AWS.
Two stacks, each with its own state file in the same S3 bucket.

| Stack | What it creates |
|---|---|
| [`bootstrap/`](bootstrap) | The S3 bucket that holds Terraform state: versioned, encrypted, public access blocked, HTTPS-only policy, old versions expire after 90 days, `prevent_destroy`. Applied once. |
| [`site/`](site) | Everything that serves the site (below). |

## What `site/` builds

- **S3** (eu-north-1): private bucket for the contents of `site/dist/`. Versioned (a bad
  deploy can be rolled back), encrypted, old versions expire after 30 days, no public access.
  The bucket policy allows reads only from this CloudFront distribution.
- **CloudFront**: Origin Access Control (signed requests to S3), AWS managed
  caching-optimized policy, HTTP/2 + HTTP/3, `PriceClass_100` (Europe + North America
  edges), custom 404 page.
- **CloudFront Function** (viewer request, [`functions/viewer-request.js`](site/functions/viewer-request.js)):
  redirects `www` to the apex and rewrites directory-style URLs (`/path/` and `/path` →
  `/path/index.html`), because a private S3 origin does no index-document resolution.
- **Response headers policy**: HSTS, CSP, `X-Content-Type-Options`, frame and referrer
  policies, and a permissions policy that disables browser features the site never uses.
- **ACM** certificate in **us-east-1** (CloudFront only accepts certificates from there,
  hence a second, aliased provider), validated through DNS records Terraform creates.
- **Route 53**: A and AAAA alias records for the apex and `www`. The hosted zone itself was
  created by domain registration and is only read (`data` source), never managed.
- **AWS Budget**: $10/month with email alerts at 50% and 100% actual spend, and when the
  forecast exceeds the limit.

Safety nets: `allowed_account_ids` makes Terraform refuse to run against any other AWS
account; every resource is tagged (`project`, `stack`, `managed-by`) via `default_tags`.

## Usage

Requirements: Terraform ≥ 1.11 (S3 native state locking) and AWS credentials for the target
account.

Account-specific values are kept out of Git:

```sh
cd infra
cp backend.hcl.example backend.hcl                              # state bucket name
cp bootstrap/terraform.tfvars.example bootstrap/terraform.tfvars  # account id
cp site/terraform.tfvars.example site/terraform.tfvars            # account id, alert email

cd site
terraform init -backend-config=../backend.hcl
terraform plan
terraform apply
```

The first time in a new account, apply `bootstrap/` first with local state, then migrate
its state into the bucket it created (`terraform init -migrate-state -backend-config=../backend.hcl`).

Until Phase 4 (GitHub Actions with OIDC), deploys are manual: `npm run build` in `site/`,
sync `site/dist/` to the site bucket, then invalidate the CloudFront cache.

See [ADR-0001](../docs/adr/0001-static-site-generator.md) for why the site is static.
