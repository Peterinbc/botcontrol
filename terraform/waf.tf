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

  #token_domains = ["bcgoat.net"]
  
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "tstbcgoatwafacl"
    sampled_requests_enabled   = true
  }
}
