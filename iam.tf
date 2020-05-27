# Creates the temporary fcs-network-user

resource "aws_iam_user" "user" {
  name = "fcs-network-user"
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

data "aws_iam_policy_document" "user" {
  statement {
    sid       = "netopsCreateVPN"
    effect    = "Allow"
    actions   = ["iam:ListAccountAliases", "ec2:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "user" {
  name   = "fcs-network-user"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.user.json
}
