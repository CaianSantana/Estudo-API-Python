terraform {
  backend "s3" {
    bucket  = "flask-tfstate-bucket"
    key     = "terraform.tfstate"
    encrypt = true
    region  = "us-west-2"
  }
}

resource "aws_s3_bucket" "tfstate_bucket" {
  bucket        = "flask-tfstate-bucket"
  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    IaC = true
  }
}

resource "aws_s3_bucket_versioning" "version_tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}