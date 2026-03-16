output "bucket_endpoint" {
  value= aws_s3_bucket.cloudfront_logs.bucket_domain_name
}