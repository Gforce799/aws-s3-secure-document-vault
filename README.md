# AWS S3 Secure Document Vault

    A hardened S3 document-vault template with KMS encryption, versioning, lifecycle retention, optional object lock, and a deny-insecure-transport bucket policy.

    **Portfolio size:** Small

    ## AWS services covered

    - Amazon S3
- AWS KMS
- IAM policy documents
- S3 lifecycle management

    ## Enterprise controls demonstrated

    - Provider pinning and repeatable Terraform workflows.
    - Encryption at rest with KMS where the service supports customer managed keys.
    - Least-privilege IAM roles and narrowly scoped service policies.
    - Consistent tagging, naming, retention, and environment separation.
    - CI checks for formatting, validation, linting, and IaC security scanning.
    - Security documentation, architecture notes, and example module usage.

    ## Quick start

    ```bash
    terraform init
    terraform fmt -recursive
    terraform validate
    terraform plan -out=tfplan
    ```

    Use `examples/standard` as the caller pattern for this template.

    ## Production hardening checklist

    - Replace example CIDR ranges, ARNs, domain names, and retention windows.
    - Connect remote state with state locking before team usage.
    - Review every IAM trust relationship against your account structure.
    - Enable branch protection and required CI checks in GitHub.
    - Run a cost estimate before deployment to a live AWS account.

    ## Repository intent

    This repository is designed as a professional AWS infrastructure portfolio
    sample. It favors clear architecture, security defaults, and reviewable
    Terraform over one-click deployment magic.
