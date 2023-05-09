# Assume role の準備 ------------------------------------------------------------------------------

data "aws_iam_policy_document" "assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}


# IAM > Roles -------------------------------------------------------------------------------------
# ECSタスクロール用のIAMロールを作成

resource "aws_iam_role" "task" {

  # Select type of trusted entity: AWS service
  # Choose a use case: Elastic Container Service
  # Select your use case: Elastic Container Service Task
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  # Attach permissions policies
  # later

  # Add tags
  tags = var.env.tags

  # Role name
  name = format("%s-%s-task-role", var.env.prefix, var.name)

  # Role description
  # skip
}


# Roles > [Created role] --------------------------------------------------------------------------
# ECSタスクロールのポリシーをアタッチ

resource "aws_iam_role_policy_attachment" "task" {
  for_each = toset(concat(
    # 必須のポリシー
    [
      #"arn:aws:iam::aws:policy/"
    ],
    # 任意のポリシー
    var.task_role_policy_arns
  ))

  role       = aws_iam_role.task.id
  policy_arn = each.value
}


# IAM > Roles -------------------------------------------------------------------------------------
# ECSタスク実行ロール用のIAMロールを作成

resource "aws_iam_role" "task_exec" {

  # Select type of trusted entity: AWS service
  # Choose a use case: Elastic Container Service
  # Select your use case: Elastic Container Service Task
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  # Attach permissions policies
  # later

  # Add tags
  tags = var.env.tags

  # Role name
  name = format("%s-%s-task-exec-role", var.env.prefix, var.name)

  # Role description
  # skip
}


# Roles > [Created role] --------------------------------------------------------------------------
# ECSタスク実行ロールのポリシーをアタッチ

resource "aws_iam_role_policy_attachment" "task_exec" {
  for_each = toset(concat(
    # 必須のポリシー
    [
      "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    ],
    # 任意のポリシー
    var.task_exec_role_policy_arns
  ))

  role       = aws_iam_role.task_exec.id
  policy_arn = each.value
}
