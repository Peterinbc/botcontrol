## Creating Cloudfront Distribution

resource "aws_cloudfront_cache_policy" "tstbcgoatcchplcy" {
  name = "myCachingpolicy"
  
  parameters_in_cache_key_and_forwarded_to_origin {
  
    cookies_config {
      cookie_behavior = "none"
    }
    
    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_distribution" "tstbcgoatcldfrntdstrbtnres" {
  
  enabled = true
  web_acl_id = aws_wafv2_web_acl.tstbcgoatwafrule.arn
  #aliases = [var.domainnaim]

  origin {
    domain_name = aws_s3_bucket_website_configuration.tstbcgoatwbst.website_endpoint
    origin_id = "tstbcgoatcldfrntdstrbtnorigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  restrictions {
    geo_restriction {
    restriction_type = "none"
    }  
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }

#   viewer_certificate {
#     acm_certificate_arn      = aws_acm_certificate.bcgoatacmcert.arn
#     ssl_support_method       = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2021"
#   }
  
  default_cache_behavior {
    cache_policy_id = aws_cloudfront_cache_policy.tstbcgoatcchplcy.id
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "tstbcgoatcldfrntdstrbtnorigin"
    viewer_protocol_policy = "https-only"
  }
  
}
