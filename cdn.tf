locals {
  s3-origin  = aws_s3_bucket.ada-s3-julio.id
  elb-origin = aws_lb.ada-lb
}

resource "aws_cloudfront_origin_access_identity" "s3-origin-access" {
    comment = "Allow CloudFront to access S3"
}

## criar um cloudfront distribution com s3 como origem

resource "aws_cloudfront_distribution" "ada-cdn-julioS3" {
  origin {
    domain_name = aws_s3_bucket.ada-s3-julio.bucket_regional_domain_name
    origin_id   = local.s3-origin

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3-origin-access.cloudfront_access_identity_path
    }
  }
  

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3-origin

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "ada-cdn-julioS3"
  }
}

resource "aws_cloudfront_distribution" "ada-cdn-elb" {
  origin {
    domain_name = aws_lb.ada-lb.dns_name
    origin_id   = "ada-elb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ada-elb"
    compress         = true

    forwarded_values {
      query_string = false
      headers      = ["Host"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  tags = {
    Name = "ada-cdn-elb"
  }
}