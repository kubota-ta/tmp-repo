# Assume role の準備
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

/**
 * IAM > Roles
 * インスタンスプロファイル用のIAMロールを作成
 */
resource "aws_iam_role" "this" {

  # Select type of trusted entity: AWS service
  # Choose a use case: EC2
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  # Attach permissions policies
  # later

  # Add tags
  tags = var.env.tags

  # Role name
  name = format("%s-%s-role", var.env.prefix, var.name)

  # Role description
  # skip
}

# マネジメントコンソールでは、インスタンスにアタッチすればプロファイルが生成されます
resource "aws_iam_instance_profile" "this" {
  name = format("%s-%s-profile", var.env.prefix, var.name)
  role = aws_iam_role.this.name
}

## Roles > [Created role]
# Attach policies
resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(concat(
    [
      # Session Managerを用いたSSH接続に必要
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
      # CloudWatch拡張用
      "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    ],
    var.policy_arns
  ))

  role       = aws_iam_role.this.id
  policy_arn = each.value
}

