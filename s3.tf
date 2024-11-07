## criar um s3 bucket

resource "aws_s3_bucket" "ada-s3-julio" {
  bucket = "ada-s3-julio"
  
  tags = {
    Name = "ada-s3-julio"
  }
}