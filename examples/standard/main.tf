module "this" {
    source = "../.."

    name        = "s3-secure-document-vault"
    environment = "dev"

noncurrent_version_expiration_days = 180
enable_object_lock                 = true
object_lock_retention_days         = 45

    tags = {
      Owner      = "platform-team"
      CostCenter = "portfolio"
    }
  }
