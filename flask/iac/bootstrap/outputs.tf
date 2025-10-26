output "bucket_tfstate" {
  value = aws_s3_bucket.tfstate_bucket.bucket
}

output "ecr_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
}
