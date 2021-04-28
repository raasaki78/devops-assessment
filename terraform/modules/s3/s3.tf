resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_glacier_vault" "rate_store_archiever" {
  name = var.glacier_vault_name
}

output "bucket_name" {
  value = var.bucket_name
}