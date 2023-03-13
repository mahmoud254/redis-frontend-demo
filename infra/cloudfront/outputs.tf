output "domain_name" {
    value = aws_cloudfront_distribution.aws_cloudfront_distribution.domain_name
}


output "distrbution_id" {
    value = aws_cloudfront_distribution.aws_cloudfront_distribution.id
}

output "oai_arn" {
    value = aws_cloudfront_origin_access_identity.example.iam_arn
}
