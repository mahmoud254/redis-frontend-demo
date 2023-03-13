terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.51.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.REGION

}

variable "REGION" {
  default = "us-east-1"
  type    = string
}

variable "BUCKET_NAME" {
  default = "www.example.com"
  type    = string
}

resource "aws_s3_bucket" "example" {
  bucket = var.BUCKET_NAME
}

resource "aws_s3_bucket_public_access_block" "example-block" {
  bucket = aws_s3_bucket.example.id
  block_public_acls       = true # true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "example-config" {
  bucket = aws_s3_bucket.example.bucket
  index_document  {
    suffix = "index.html"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.example.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [module.worpress_cloudfront.oai_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.bucket
  policy = data.aws_iam_policy_document.s3_policy.json
}

module "worpress_cloudfront" {
    source = "./cloudfront"
    env = "dev"
    origin_arn = aws_s3_bucket.example.arn
    origin_domain_name = aws_s3_bucket.example.bucket_regional_domain_name # aws_s3_bucket_website_configuration.example-config.website_endpoint
    origin_id = aws_s3_bucket.example.bucket_regional_domain_name
    alias_cloudfront_list = []
    force_ssl = false
    use_waf =  false
    default_root_object = "index.html"
    use_cache = true
}


# variable "ACCOUNT_ID" {
#   default = "us-east-1"
#   type    = string
# }
# resource "aws_s3_bucket_policy" "example-policy" {
#   bucket = aws_s3_bucket.example.bucket
#   policy = templatefile("s3-policy.json",
#     { bucket=var.BUCKET_NAME,account_id=var.ACCOUNT_ID, distrbution_id=module.worpress_cloudfront.distrbution_id}
#   )
# }

// Uploading the site files
# resource "aws_s3_object" "file_1" {
#   bucket = aws_s3_bucket.example.id
#   key    = "index.html"
#   source = "../index.html"
#   acl    = "public-read"
#   content_type = "text/html"
# }
# resource "aws_s3_object" "file_2" {
#   bucket = aws_s3_bucket.example.id
#   key    = "styles.css"
#   source = "../styles.css"
#   acl    = "public-read"
# }
# resource "aws_s3_object" "file_3" {
#   bucket = aws_s3_bucket.example.id
#   key    = "script.js"
#   source = "../script.js"
#   acl    = "public-read"
# }
# resource "aws_s3_object" "file_4" {
#   bucket = aws_s3_bucket.example.id
#   key    = "error.jpg"
#   source = "../error.jpg"
#   acl    = "public-read"
# }