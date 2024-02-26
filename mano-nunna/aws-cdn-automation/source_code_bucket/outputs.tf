output "OAI_ID" {
  value = aws_cloudfront_origin_access_identity.my_oai.cloudfront_access_identity_path
}