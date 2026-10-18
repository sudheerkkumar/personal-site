# 4 records: apex + www, each for IPv4 (A) and IPv6 (AAAA).
locals {
  dns_records = {
    for pair in setproduct([local.domain, "www.${local.domain}"], ["A", "AAAA"]) :
    "${pair[0]}-${pair[1]}" => { name = pair[0], type = pair[1] }
  }
}

resource "aws_route53_record" "site" {
  for_each = local.dns_records

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type

  # Alias = point directly at an AWS resource (free lookups, works on the apex)
  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}