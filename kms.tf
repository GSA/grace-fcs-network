data "aws_iam_policy_document" "kms_key" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      identifiers = [
        local.root_account_arn
      ]
      type = "AWS"
    }
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "Allow VPC flow log decryption"
    effect = "Allow"
    principals {
      identifiers = local.log_viewer_roles
      type        = "AWS"
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      "*"
    ]
  }
}

# arn:aws:iam::123456789012:role/OrganizationAccountAccessRole
resource "aws_kms_key" "kms_key" {
  description             = "Key for GRACE FCS Network S3 bucket (bucket: ${local.bucket_name})"
  deletion_window_in_days = 7
  enable_key_rotation     = "true"

  policy = data.aws_iam_policy_document.kms_key.json
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${local.bucket_name}"
  target_key_id = aws_kms_key.kms_key.key_id
}
