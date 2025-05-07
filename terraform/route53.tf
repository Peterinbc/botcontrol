## Creating route 53 records ##

data "aws_route53_zone" "bcgoatr53zone" {
  name = var.domainnaim
}

resource "aws_route53_record" "bcgoatr53cldfrntrecord" {
  
  zone_id = data.aws_route53_zone.bcgoatr53zone.zone_id
  name    = var.domainnaim
  type    = "A"
  
  alias {
    zone_id = aws_cloudfront_distribution.tstbcgoatcldfrntdstrbtnres.hosted_zone_id
    name = aws_cloudfront_distribution.tstbcgoatcldfrntdstrbtnres.domain_name 
    evaluate_target_health = true
  }
  
}


