# infra

Placeholder. Terraform for AWS hosting arrives in **Phase 3**.

## Planned shape

- **S3** bucket (private) holding the contents of `site/dist/`
- **CloudFront** distribution in front of S3, using Origin Access Control (OAC)
- **ACM** certificate (must be in `us-east-1` for CloudFront)
- **Route 53** hosted zone and alias records for `sudheerkancharla.dev`

## Known requirements for the static build

Astro outputs "directory-style" pages, e.g. `case-studies/foo/index.html`, linked as
`/case-studies/foo/`. CloudFront's *default root object* only applies to `/`, not to
sub-paths, and a private S3 origin (OAC) does not do index-document resolution.
So Phase 3 needs:

1. **A CloudFront Function (viewer request)** that rewrites URIs:
   - `/path/` → `/path/index.html`
   - `/path` (no file extension) → `/path/index.html`
2. **Custom error responses** mapping S3's `403` (returned for missing keys when the
   bucket is private) and `404` to `/404.html` with HTTP status `404`.

See [ADR-0001](../docs/adr/0001-static-site-generator.md) for context.
