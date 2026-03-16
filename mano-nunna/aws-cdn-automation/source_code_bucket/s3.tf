resource "aws_s3_bucket" "static_website" {
  bucket = var.source_code_bucket_name
  tags=var.src_bucket_tags
}
resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "static_website" {
  depends_on = [ aws_s3_bucket_ownership_controls.static_website ]
  bucket = aws_s3_bucket.static_website.id
  acl    = var.src_bucket_acl
}


resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = var.index_document_suffix
  }

  error_document {
    key = var.error_document_key
  }
}

resource "aws_s3_object" "index" {
  key="index.html"
  depends_on = [ aws_s3_bucket_policy.static_website ]
  bucket = aws_s3_bucket.static_website.id
  source = "${path.module}/index.html"
  content_type = var.content_type
}

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_website.bucket

  policy = jsonencode({
    Version = "2008-10-17",
    Id      = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid       = "1",
        Effect    = "Allow",
        Principal = {
          AWS = "${aws_cloudfront_origin_access_identity.my_oai.iam_arn}"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      },
    ],
  })
}

resource "aws_cloudfront_origin_access_identity" "my_oai" {
  comment = "BiMo Origin Access Identity"
}