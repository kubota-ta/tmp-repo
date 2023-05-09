data "aws_caller_identity" "current" {}

locals {
  available_customer_managed_policies = merge([
    for k, v in var.template : {
      for i in v.available_customer_managed_policies :
      "${i}" => "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${i}"
    }
  ]...)

  customer_managed_policies = merge([
    for k, v in var.template : v.customer_managed_policies
  ]...)
}

data "template_file" "this" {
  for_each = local.customer_managed_policies
  template = jsonencode(each.value)
  vars = merge(
    # 自動補完
    { aws_id = data.aws_caller_identity.current.account_id },
    # 引数入力
    var.template_vars
  )
}

resource "aws_iam_policy" "this" {
  for_each = data.template_file.this
  name     = "${var.env.prefix}-${each.key}"
  policy   = each.value.rendered
}
