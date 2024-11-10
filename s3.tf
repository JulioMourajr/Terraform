## criar um s3 bucket

resource "aws_s3_bucket" "ada-s3-julio" {
  bucket = "ada-s3-julio"

  tags = {
    Name = "ada-s3-julio"
  }
}

resource "aws_s3_bucket_policy" "ada-s3-julio-policy" {
  bucket = aws_s3_bucket.ada-s3-julio.bucket
  policy = local.policy
}

resource "aws_s3_bucket_public_access_block" "allow_access" {
  bucket                  = aws_s3_bucket.ada-s3-julio.id
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_policy     = true
}