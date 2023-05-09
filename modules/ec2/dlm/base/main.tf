/**
 * Lifecycle Manager > EBS snapshot policy の Default role で作成される IAMRole と Policy
 */
data "template_file" "this" {
  for_each = toset([
    ## for EBS snapshot policy
    "AWSDataLifecycleManagerServiceRole",
    ## for EBS-backed AMI policy
    "AWSDataLifecycleManagerServiceRoleForAMIManagement",
  ])
  template = file("${path.module}/files/${each.key}.yml")
  vars = {
  }
}

resource "aws_iam_policy" "this" {
  for_each = data.template_file.this
  name     = "${var.env.prefix}-${each.key}"
  policy   = jsonencode(yamldecode(each.value.rendered)["Policy"])
}

resource "aws_iam_role" "for_snapshot" {
  assume_role_policy = jsonencode(yamldecode(
    data.template_file.this["AWSDataLifecycleManagerServiceRole"].rendered
  )["AssumeRole"])
  managed_policy_arns = [aws_iam_policy.this["AWSDataLifecycleManagerServiceRole"].arn]
  tags                = var.env.tags
  name                = "${var.env.prefix}-AWSDataLifecycleManagerDefaultRole"
  path                = "/service-role/"
}

resource "aws_iam_role" "for_ami" {
  assume_role_policy = jsonencode(yamldecode(
    data.template_file.this["AWSDataLifecycleManagerServiceRoleForAMIManagement"].rendered
  )["AssumeRole"])
  managed_policy_arns = [aws_iam_policy.this["AWSDataLifecycleManagerServiceRoleForAMIManagement"].arn]
  tags                = var.env.tags
  name                = "${var.env.prefix}-AWSDataLifecycleManagerDefaultRoleForAMIManagement"
  path                = "/service-role/"
}
