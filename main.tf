data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  derived_bucket_name = "${local.name_prefix}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  vault_bucket_name   = var.bucket_name != "" ? var.bucket_name : local.derived_bucket_name
}

resource "aws_kms_key" "vault" {
  description             = "KMS key for ${local.name_prefix} document vault"
  deletion_window_in_days = var.kms_deletion_window_days
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "vault" {
  name          = "alias/${local.name_prefix}-document-vault"
  target_key_id = aws_kms_key.vault.key_id
}

resource "aws_s3_bucket" "vault" {
  bucket              = local.vault_bucket_name
  object_lock_enabled = var.enable_object_lock
  tags                = local.tags
}

resource "aws_s3_bucket_public_access_block" "vault" {
  bucket                  = aws_s3_bucket.vault.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "vault" {
  bucket = aws_s3_bucket.vault.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vault" {
  bucket = aws_s3_bucket.vault.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.vault.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "vault" {
  bucket = aws_s3_bucket.vault.id

  rule {
    id     = "retain-current-and-expire-old-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "vault" {
  count  = var.enable_object_lock ? 1 : 0
  bucket = aws_s3_bucket.vault.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = var.object_lock_retention_days
    }
  }
}

data "aws_iam_policy_document" "vault" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.vault.arn,
      "${aws_s3_bucket.vault.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "vault" {
  bucket = aws_s3_bucket.vault.id
  policy = data.aws_iam_policy_document.vault.json
}
