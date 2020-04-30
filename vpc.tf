
# Creating custom VPC for given CIDR
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-${var.name}-${local.env_id}-${local.region_id}"
  }
}


# Creating VPC flow logs
resource "aws_flow_log" "default" {
  log_destination      = module.vpc_flow_logs_bucket.this_s3_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}

resource "aws_iam_role" "vpc_flow_log_role" {
  name = "${local.name}-VPC-flow-logs-role"

  tags = {
    Name = "${local.name}-Role-Flowlogs"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "${local.name}-VPC-flow-logs-policy"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Creating private subnets distributed among all availability zones
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.main.id
  count                   = local.num_azs
  cidr_block              = cidrsubnet(var.cidr, ceil(local.num_azs / 2), count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-priv-subnet-${substr(data.aws_availability_zones.available.names[count.index], -2, min(2, length(data.aws_availability_zones.available.names[count.index])))}"
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "RT-${var.name}"
  }
}

resource "aws_route_table_association" "default" {
  count          = local.num_azs
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.default.id
}
