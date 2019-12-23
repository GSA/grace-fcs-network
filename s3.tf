module "vpc_flow_logs_bucket" {
  source         = "terraform-aws-modules/s3-bucket/aws"
  bucket         = local.bucket_name
  acl            = "private"
  versioning     = var.vpc_flow_logs_bucket_versioning
  force_destroy  = var.vpc_flow_logs_bucket_force_destroy
  lifecycle_rule = var.vpc_flow_logs_bucket_lifecycle
  tags           = var.vpc_flow_logs_bucket_tags
  logging        = var.vpc_flow_logs_bucket_access_logging

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
