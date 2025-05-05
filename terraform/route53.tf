## Creating route 53 records ##

resource "aws_route53_zone" "bcgoatr53zone" {
  name = var.domainnaim
}

data "aws_route53_zone" "bcgoatr53zone" {
    depends_on = [ aws_route53_zone.bcgoatr53zone ]
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

# resource "aws_route53_record" "bcgoatr53acmcnamerecord" {
#   zone_id = aws_route53_zone.bcgoatr53zone.zone_id
#   # TO BE DEALT WITH ## name    = ""
#   type    = "CNAME"
#   ttl     = 300
#   ## TO BE DEALT WITH records = [aws_cloudfront_distribution.tstbcgoatcldfrntdstrbtnres.arn]
# }

