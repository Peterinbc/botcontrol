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

# resource "aws_s3_bucket_acl" "tstbcgoats3acl" {
#   depends_on = [ aws_s3_bucket_ownership_controls.tstbcgoatownercntrl ]
#   bucket = aws_s3_bucket.tstbcgoatbkt.id
#   acl = "private"
# }

resource "aws_s3_bucket_versioning" "tstbcgoatvrsnng" {
  bucket = aws_s3_bucket.tstbcgoatbkt.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tstbcgoatbktpblcaccss" {
  bucket = aws_s3_bucket.tstbcgoatbkt.id
}

resource "aws_s3_bucket_policy" "tstbcgoatbktpol" {
  depends_on = [
    aws_s3_bucket_public_access_block.tstbcgoatbktpblcaccss
  ]
  bucket = aws_s3_bucket.tstbcgoatbkt.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
              "s3:GetObject",
              "s3:PutObject",
            ],
            "Resource": "${aws_s3_bucket.tstbcgoatbkt.arn}/*"
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
  source = "../websitefiles/${each.value}"
  content_type = "text/html"
}
