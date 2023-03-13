

data "aws_cloudfront_cache_policy" "CachingDisabled" {
name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "CachingOptimized" {
name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "CORS-S3Origin" {
name = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_origin_request_policy" "CORS-AllViewer" {
name = "Managed-AllViewer"
}

data "aws_cloudfront_response_headers_policy" "CORS-With-Preflight" {
name = "Managed-CORS-With-Preflight"
}

resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "OAI"
}

resource "aws_cloudfront_distribution" "aws_cloudfront_distribution" {
  depends_on = [
    var.origin_arn
  ]

  origin {
    domain_name = var.origin_domain_name
    origin_id = var.origin_id
   
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
    }
  }

  

  enabled             = true
  is_ipv6_enabled     = true
  aliases = var.force_ssl == true ? var.alias_cloudfront_list : null
  default_root_object  = var.default_root_object 
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id =  var.origin_id

    cache_policy_id             = var.use_cache == false ? data.aws_cloudfront_cache_policy.CachingDisabled.id : data.aws_cloudfront_cache_policy.CachingOptimized.id
    origin_request_policy_id    = data.aws_cloudfront_origin_request_policy.CORS-S3Origin.id
    response_headers_policy_id  = data.aws_cloudfront_response_headers_policy.CORS-With-Preflight.id

    viewer_protocol_policy = var.force_ssl == true ? "redirect-to-https" : "allow-all"  # allow-all, redirect-to-https
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  price_class = "PriceClass_All"

  dynamic viewer_certificate {
    for_each = var.force_ssl == true ? [1] : []
    content {
      acm_certificate_arn = var.acm_certificate_arn_cloudfront
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }

  dynamic viewer_certificate {
    for_each = var.force_ssl == true ? [] : [1]
    content {
      cloudfront_default_certificate = true
    }
  }
  
  web_acl_id = var.use_waf ? var.web_acl_id : null 
}
