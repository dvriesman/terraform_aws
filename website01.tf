resource "aws_s3_bucket" "website" {
  bucket = "${var.bucket_name}"
  acl = "public-read"

  tags {
    Name = "Website"
    Environment = "test of terraform"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT","POST"]
    allowed_origins = ["*"]
    expose_headers = ["ETag"]
    max_age_seconds = 3000
  }

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}
resource "aws_s3_bucket" "website_redirect" {
  bucket = "www.${var.bucket_name}"
  acl = "public-read"

  website {
    redirect_all_requests_to = "${var.bucket_name}"
  }
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${var.bucket_name}.s3.amazonaws.com"
    origin_id   = "website"
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Cloudfront from TerraForm"
  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "website"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  #price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    Environment = "test"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${var.bucket_name}"
  key    = "index.html"
  source = "./site01/index.html"
  etag   = "${md5(file("./site01/index.html"))}"
}
