output "bucket_name" {
  description = "Document vault bucket name."
  value       = aws_s3_bucket.vault.id
}

output "bucket_arn" {
  description = "Document vault bucket ARN."
  value       = aws_s3_bucket.vault.arn
}

output "kms_key_arn" {
  description = "KMS key ARN used for bucket encryption."
  value       = aws_kms_key.vault.arn
}
