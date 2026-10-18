# The function above, deployed to CloudFront
resource "aws_cloudfront_function" "viewer_request" {
  name    = "personal-site-viewer-request"
  runtime = "cloudfront-js-2.0"
  comment = "www redirect + clean URLs"
  publish = true
  code    = file("${path.module}/functions/viewer-request.js")
}

# Security headers added to every response
resource "aws_cloudfront_response_headers_policy" "security" {
  name = "personal-site-security-headers"

  security_headers_config {
    # Browsers must always use HTTPS for this domain (2 years)
    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      override                   = true
    }

    # Don't guess file types (prevents some script-injection tricks)
    content_type_options {
      override = true
    }

    # No other site may show this page inside a frame (anti-clickjacking)
    frame_options {
      frame_option = "DENY"
      override     = true
    }

    # When following a link away, send only the domain, not the full URL
    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }

    # Content Security Policy: what the page may load, and from where
    content_security_policy {
      content_security_policy = join("; ", [
        "default-src 'self'",
        "img-src 'self' data:",
        "style-src 'self' 'unsafe-inline'",
        "script-src 'self' 'unsafe-inline'",
        "font-src 'self'",
        "object-src 'none'",
        "base-uri 'self'",
        "form-action 'none'",
        "frame-ancestors 'none'",
      ])
      override = true
    }
  }

  # Disable browser features the site never uses
  custom_headers_config {
    items {
      header   = "Permissions-Policy"
      value    = "camera=(), microphone=(), geolocation=(), payment=()"
      override = true
    }
  }
}