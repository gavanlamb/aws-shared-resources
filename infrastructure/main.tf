locals {
  tags = {
    environment = var.environment
    service = var.service
    terraform = true
    region = var.region
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "pipeline-test-gfljk"
  acl    = "private"
}

resource "aws_instance" "shared" {
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  disable_api_termination = true
  
  tags = local.tags
}