# AWS's standard caching settings for static sites
data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}

# How CloudFront proves its identity to S3 (signed requests)
resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "personal-site-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  comment             = "personal-site"
  default_root_object = "index.html"
  aliases             = [local.domain, "www.${local.domain}"]
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  price_class         = "PriceClass_100"   # Europe + North America edges (cheapest)

  origin {
    origin_id                = "s3-site"
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-site"
    viewer_protocol_policy = "redirect-to-https"   # http:// → https://
    allowed_methods        = ["GET", "HEAD"]       # read-only site
    cached_methods         = ["GET", "HEAD"]
    compress               = true                  # gzip/brotli, faster pages
    cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.viewer_request.arn
    }
  }

  # Missing page → show our custom 404 page
  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 60
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.site.certificate_arn
    ssl_support_method       = "sni-only"         # free; "vip" costs $600/month!
    minimum_protocol_version = "TLSv1.2_2021"     # modern, secure TLS only
  }
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.site.id
}

output "site_bucket" {
  value = aws_s3_bucket.site.bucket
}