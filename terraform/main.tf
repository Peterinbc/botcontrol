## Initial Setup

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.96.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

## Creating S3 Bucket

resource "aws_s3_bucket" "tstbcgoatbkt" {
  bucket = "tstbcgoatbucket"
}

resource "aws_s3_bucket_ownership_controls" "tstbcgoatownercntrl" {
  bucket = aws_s3_bucket.tstbcgoatbkt.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_acl" "tstbcgoats3acl" {
  depends_on = [ aws_s3_bucket_ownership_controls.tstbcgoatownercntrl ]
  bucket = aws_s3_bucket.tstbcgoatbkt.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "tstbcgoatvrsnng" {
  bucket = aws_s3_bucket.tstbcgoatbkt.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "tstbcgoatbktpol" {
  bucket = aws_s3_bucket.tstbcgoatbkt.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::bcgoat-net-test/*"
        }
    ]
})
}

resource "aws_s3_bucket_website_configuration" "tstbcgoatwbst" {
    bucket = aws_s3_bucket.tstbcgoatbkt.id
    
    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "error.html"
    }
}

## Uploading a files to the bucket ##

resource "aws_s3_object" "tstbcgoatupld" {
  bucket = aws_s3_bucket.tstbcgoatbkt.id
  for_each = fileset("../websitefiles/", "*.html")
  key = each.value
}

## Creating CloudFront WAF rules

resource "aws_wafv2_web_acl" "tstbcgoatwafrule" {
  name        = "tstbcgoatwafacl"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 0

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        version = "Version_1.0"
        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level = "TARGETED"
            enable_machine_learning = true
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  token_domains = ["bcgoat.net"]
  
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "tstbcgoatwafacl"
    sampled_requests_enabled   = true
  }
}

## Creating Cloudfront Distribution

resource "aws_cloudfront_distribution" "tstbcgoatcldfrntdstrbtnres" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.tstbcgoatwbst.website_endpoint
    origin_id = "tstbcgoatcldfrntdstrbtnorigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  enabled = true
  restrictions {
    geo_restriction {
    restriction_type = "none"
    #locations = []  
    }  
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "tstbcgoatcldfrntdstrbtnorigin"
    viewer_protocol_policy = "https-only"
  }
}