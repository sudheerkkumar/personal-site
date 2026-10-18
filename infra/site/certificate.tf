# Look up the hosted zone Route 53 created when you registered the domain.
# "data" = read only: Terraform uses it but never manages or deletes it.
data "aws_route53_zone" "main" {
  name = local.domain
}

# Request the certificate (in us-east-1, for CloudFront)
resource "aws_acm_certificate" "site" {
  provider                  = aws.us_east_1
  domain_name               = local.domain
  subject_alternative_names = ["www.${local.domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true   # if ever replaced, create new before deleting old
  }
}

# Add the DNS records AWS asks for to prove domain ownership
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.site.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id         = data.aws_route53_zone.main.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

# Wait until AWS confirms the records and issues the certificate
resource "aws_acm_certificate_validation" "site" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.site.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.site.certificate_arn
}