terraform {
  required_version = ">= 0.12"
  backend "local" {
    path = "grace-fcs-network.tfstate"
  }
}

locals {
  env_table = {
    "development"   = "D"
    "dev"           = "D"
    "test"          = "T"
    "testing"       = "T"
    "staging"       = "S"
    "preprod"       = "S"
    "preproduction" = "S"
    "lab"           = "L"
    "sandbox"       = "L"
    "production"    = "P"
    "prod"          = "P"
  }
  region_table = {
    "us-east-1"     = "E"
    "us-east-2"     = "E"
    "us-west-1"     = "W"
    "us-west-2"     = "W"
    "us-gov-east-1" = "C"
    "us-gov-west-1" = "C"
  }
  name               = "${var.name}-${var.appenv}"
  notification_topic = "${var.name}-${var.appenv}-notification-topic"
  bucket_name        = "${var.name}-${var.appenv}-vpc-flowlogs"
  org_admin_role     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/OrganizationAccountAccessRole"
  root_account_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  log_viewer_roles   = length(var.log_viewer_roles) == 0 ? [local.org_admin_role] : var.log_viewer_roles
  num_azs            = length(data.aws_availability_zones.available.names)
  region_id          = local.region_table[lower(data.aws_region.current.name)]
  env_id             = local.env_table[lower(var.appenv)]
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

provider "aws" {}
