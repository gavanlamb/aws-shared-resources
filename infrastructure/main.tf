resource "aws_s3_bucket" "bucket" {
  bucket = "pipeline-test-gfljk"
  acl    = "private"
}
