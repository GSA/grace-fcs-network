# <a name="top">GRACE FCS Network</a> [![CircleCI](https://circleci.com/gh/GSA/grace-fcs-network.svg?style=svg)](https://circleci.com/gh/GSA/grace-fcs-network)

## <a name="description">Description</a>
The code provided within this component will create the AWS resources necessary to configure the customer-side VPN for connectivity to FCS and on-prem. An outline for the manual creation of the required resources is also provided below.


## <a name="contents">Table of Contents</a>

- [Description](#description)
- [Diagram](#diagram)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Deployment Guide](#guide)
- [Security Compliance](#security)
- [Public Domain](#license)

## <a name="diagram">Diagram</a>

![grace-fcs-network layout](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.github.com/GSA/grace-fcs-network/master/res/diagram.uml)

[top](#top)

## <a name="input">Inputs</a>

| Name                 | Description |
| -------------------- | ------------|
| appenv | (optional) The environment in which the script is running (development | test | staging | lab | production) |
| cidr | (required) CIDR block of VPC to be created |
| gateways | (required) List of map that defines the Customer Gateway addresses and names |
| log_viewer_roles | (optional, default: OrganizationAccountAccessRole) The list of IAM Role ARNs allowed to decrypt and view flow logs |
| name | (required) The name used to identify the customer or project associated with the AWS resources |
| remote_bgp_asn | (required) The remote's Border Gateway Protocol (BGP) Autonomous System Number (ASN) |
| sns_topics | (optional, default: []) List of SNS topics for VPN tunnel alerting |
| vpc_flow_logs_bucket_access_logging | (optional, default: {}) Map containing access bucket logging configuration. |
| vpc_flow_logs_bucket_force_destroy | (optional, default: false) The boolean value specifying whether or not to force destroy the bucket |
| vpc_flow_logs_bucket_lifecycle | (optional, default: {}) VPC flow log lifecycle_rule block |
| vpc_flow_logs_bucket_tags | (optional) A mapping of tags to assign to the bucket. |
| vpc_flow_logs_bucket_versioning | (optional, default: { enabled = true }) VPC flow log bucket versioning enabled (true/false) |
| vpn_connection_static_routes_destinations | (required if vpn_connection_static_routes_only=true) A list of the CIDR block associated with the local subnet of the customer network. (eg: ["10.100.0.0/32"]) |
| vpn_connection_static_routes_only | (Optional, Default false) Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP. If this is set to true, vpn_connection_static_routes_destinations must also be set. |

## <a name="input">Outputs</a>

## <a name="guide">Deployment Guide</a>

### Prerequisites
* Must have requested FCS Networking Capability from the GRACE team
* Must have terraform installed (see: [Installing Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html))
* Must have an AWS IAM User account with administrative access
* Must have an access key configured for AWS (see: [Environment Variables To Configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html))
* Should have git installed (prefered) (see: [Getting started with GitHub](https://help.github.com/en/github/getting-started-with-github/set-up-git))

### Deployment
* Clone this repository locally (run: `git clone https://github.com/GSA/grace-fcs-network`)
    * *If you do not have git installed, you can simply download and extract the folder using the green download button at the top-right.*
* Save the `terraform.tfvars` provided by the GRACE team in the root of the `grace-fcs-network` folder that was created
* Open a command prompt inside the `grace-fcs-network` folder and run `terraform plan`
* If you're ready to deploy and understand the plan, run `terraform apply`
* In the output from the terraform apply command you should see two variables `aws_access_key_id` and `aws_secret_access_key` these values need to be securely provided to the GRACE team

Once the connection has been established and you have confirmed connectivity you should run this final command:

`terraform destroy -target=aws_iam_access_key.user -target=aws_iam_user.user`

This command will destroy the access key and user account used by the GRACE team during the deployment.

## <a name="security">Security Compliance</a>

## <a name="license">Public domain</a>

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
