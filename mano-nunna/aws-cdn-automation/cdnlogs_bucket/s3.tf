#s3 bucket for storing cdn logs
resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = var.bucket_name
  tags =var.bucket_tags 
  force_destroy = true
  
}

resource "aws_s3_bucket_ownership_controls" "cdn" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cdn_log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.cdn]
  bucket = aws_s3_bucket.cloudfront_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "cloudfront_logs_policy" {
  bucket = aws_s3_bucket.cloudfront_logs.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.cloudfront_logs.arn}",
          "${aws_s3_bucket.cloudfront_logs.arn}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:cloudfront::${var.account_id}:distribution/*"
          }
        }
      }
    ]
  })
}

