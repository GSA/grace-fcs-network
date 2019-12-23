variable "name" {
  type        = string
  description = "(required) The name used to identify the customer or project associated with the AWS resources"
}

variable "gateways" {
  type        = list(map(string))
  description = "(required) List of map that defines the Customer Gateway addresses and names"
}

variable "cidr" {
  type        = string
  description = "(required) CIDR block of VPC to be created"
}

variable "remote_bgp_asn" {
  type        = string
  description = "(required) The remote's Border Gateway Protocol (BGP) Autonomous System Number (ASN)"
}

variable "sns_topics" {
  type        = list(string)
  default     = []
  description = "(optional, default: []) List of SNS topics for VPN tunnel alerting"
}

variable "log_viewer_roles" {
  type        = list(string)
  default     = []
  description = "(optional, default: OrganizationAccountAccessRole) The list of IAM Role ARNs allowed to decrypt and view flow logs"
}

variable "vpc_flow_logs_bucket_force_destroy" {
  type        = bool
  default     = false
  description = "(optional, default: false) The boolean value specifying whether or not to force destroy the bucket"
}

variable "vpc_flow_logs_bucket_versioning" {
  type        = map(string)
  default     = { enabled = true }
  description = "(optional, default: { enabled = true }) VPC flow log bucket versioning enabled (true/false)"
}

variable "vpc_flow_logs_bucket_access_logging" {
  type        = map(string)
  default     = {}
  description = "(optional, default: {}) Map containing access bucket logging configuration."
}

variable "vpc_flow_logs_bucket_lifecycle" {
  type        = map(string)
  default     = {}
  description = "(optional, default: {}) VPC flow log lifecycle_rule block"
}

variable "vpc_flow_logs_bucket_tags" {
  type        = map(string)
  default     = {}
  description = "(optional) A mapping of tags to assign to the bucket."
}

variable "vpn_connection_static_routes_only" {
  type        = bool
  default     = false
  description = "(Optional, Default false) Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP. If this is set to true, vpn_connection_static_routes_destinations must also be set."
}

variable "vpn_connection_static_routes_destinations" {
  type        = list(string)
  description = "(required if vpn_connection_static_routes_only=true) A list of the CIDR block associated with the local subnet of the customer network. (eg: [\"10.100.0.0/32\"])"
}

variable "appenv" {
  type        = string
  default     = "development"
  description = "(optional) The environment in which the script is running (development | test | staging | lab | production)"
}