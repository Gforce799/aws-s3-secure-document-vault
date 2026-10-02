variable "aws_region" {
  description = "AWS region used for primary resources."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Short workload name used for resource naming."
  type        = string
  default     = "s3-secure-document-vault"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,32}$", var.name))
    error_message = "Use 3-32 lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, test, stage, or prod."
  }
}

variable "tags" {
  description = "Additional tags merged into all supported resources."
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Optional globally unique bucket name. Leave empty to derive one from account and region."
  type        = string
  default     = ""
}

variable "noncurrent_version_expiration_days" {
  description = "Days to retain noncurrent object versions."
  type        = number
  default     = 90
}

variable "enable_object_lock" {
  description = "Enable governance-mode object lock. Must be decided at bucket creation."
  type        = bool
  default     = false
}

variable "object_lock_retention_days" {
  description = "Default governance retention period when object lock is enabled."
  type        = number
  default     = 30
}

variable "kms_deletion_window_days" {
  description = "KMS key deletion window."
  type        = number
  default     = 30
}
