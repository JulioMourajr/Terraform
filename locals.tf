data "aws_caller_identity" "current" {

}

data "aws_cloudfront_distribution" "s3-cdn" {
  id = aws_cloudfront_distribution.ada-cdn-julioS3.id
}

locals {
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "PolicyForCloudFrontPrivateContent",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.ada-s3-julio.bucket}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : "arn:aws:cloudfront::${data.aws_caller_identity.current.id}:distribution/${data.aws_cloudfront_distribution.s3-cdn.id}"
          }
        }
      }
    ]
    }
  )
}