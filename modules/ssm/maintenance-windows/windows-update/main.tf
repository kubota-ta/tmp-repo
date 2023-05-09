# Assume role の準備
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
  }
}
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "pass_role" {
  statement {
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.env.prefix}-AmazonSSMAutomationRole"]
  }
}

/**
 * IAM > Roles > [Create role]
 * SSM Automation 用の IAMRole
 */
resource "aws_iam_role" "this" {

  # Select type of trusted entity: AWS service
  # Choose a use case: Systems Manager
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  # Attach permissions policies
  managed_policy_arns = [
    # aws:changeInstanceState (Start/Stop) に必要
    "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
  ]

  # Add tags
  tags = var.env.tags

  # Role name
  name = "${var.env.prefix}-AmazonSSMAutomationRole"

  # Role description
  # skip

  /**
   * IAM > Roles > [Created role] > Permissions > [Add inline policy]
   */
  inline_policy {
    name = "passrole"
    # aws:runCommand (AWS-InstallWindowsUpdates) に必要
    policy = data.aws_iam_policy_document.pass_role.json
  }
}

/**
 * AWS Systems Manager > Documents > [Create document] > Automation
 */
resource "aws_ssm_document" "this" {
  document_type   = "Automation"
  document_format = "YAML"

  ## Document details
  # Name
  name = "${var.env.prefix}-InstallWindowsUpdates"

  # Editor > [Edit]
  content = <<__DOC__
description: Installs Microsoft Windows updates.
schemaVersion: '0.3'
parameters:
  InstanceId:
    type: StringList
    description: EC2 Instance Ids
mainSteps:
  - name: isInstanceStopped
    action: 'aws:changeInstanceState'
    maxAttempts: 1
    timeoutSeconds: 60
    onFailure: 'step:runWindowsUpdateAndExit'
    inputs:
      InstanceIds: '{{InstanceId}}'
      CheckStateOnly: true
      DesiredState: stopped
    nextStep: startInstance
  - name: runWindowsUpdateAndExit
    action: 'aws:runCommand'
    maxAttempts: 1
    timeoutSeconds: 3600
    onFailure: Abort
    inputs:
      DocumentName: AWS-InstallWindowsUpdates
      InstanceIds: '{{InstanceId}}'
      Parameters:
        Action: Install
        AllowReboot: 'False'
    isEnd: true
  - name: startInstance
    action: 'aws:changeInstanceState'
    maxAttempts: 1
    timeoutSeconds: 600
    onFailure: Abort
    inputs:
      InstanceIds: '{{InstanceId}}'
      CheckStateOnly: false
      DesiredState: running
    nextStep: runWindowsUpdateAndStopped
  - name: runWindowsUpdateAndStopped
    action: 'aws:runCommand'
    maxAttempts: 1
    timeoutSeconds: 3600
    onFailure: Abort
    inputs:
      DocumentName: AWS-InstallWindowsUpdates
      InstanceIds: '{{InstanceId}}'
      Parameters:
        Action: Install
        AllowReboot: 'True'
    nextStep: stopInstance
  - name: stopInstance
    action: 'aws:changeInstanceState'
    maxAttempts: 1
    timeoutSeconds: 600
    onFailure: Abort
    inputs:
      InstanceIds: '{{InstanceId}}'
      CheckStateOnly: false
      DesiredState: stopped
    isEnd: true
__DOC__

  /**
   * AWS Systems Manager > Documents > [Created document]
   */
  ## Details
  # Tags
  tags = var.env.tags
}

/**
 * AWS Systems Manager > Maintenance Windows > [Create maintenance window]
 */
resource "aws_ssm_maintenance_window" "this" {
  ## Provide maintenance window details

  # Name
  name = "${var.env.prefix}-InstallWindowsUpdates"

  # Allow unregistered targets: Yes
  allow_unassociated_targets = true

  ## Schedule
  schedule = "cron(00 21 * * ? *)"
  duration = 2
  cutoff   = 1

  ## Manage tags
  tags = var.env.tags
}

# 停止中のインスタンスは対象外になるのでID列挙する
data "aws_instances" "this" {
  instance_tags        = var.instance_tags
  instance_state_names = ["pending", "running", "stopping", "stopped"]
}

/**
 * AWS Systems Manager > Maintenance Windows > [Created window]
 * > Targets > [Register target]
 */
resource "aws_ssm_maintenance_window_target" "this" {
  ## Maintenance window target details
  # Maintenance window
  window_id     = aws_ssm_maintenance_window.this.id
  resource_type = "INSTANCE"

  # Target name
  name = "SSMWindowsUpdate"

  # Description
  description = "tagged SSMWindowsUpdate"

  ## Targets
  ## Target selection: Specify instance tags
  #targets {
  #  key    = "tag:SSMWindowsUpdate"
  #  values = ["true"]
  #}
  ## UI上では停止中インスタンスが選択肢に並びません
  ## 起動して登録するかCLIを使用する
  targets {
    key    = "InstanceIds"
    values = data.aws_instances.this.ids
  }
}

/**
 * AWS Systems Manager > Maintenance Windows > [Created window]
 * > Tasks > [Register tasks] > Register Automation task
 */
resource "aws_ssm_maintenance_window_task" "this" {
  ## Maintenance window task details
  # Maintenance window
  window_id = aws_ssm_maintenance_window.this.id

  # Name
  name = "InstallWindowsUpdates"

  ## Automation document
  task_type = "AUTOMATION"

  # Document
  task_arn = aws_ssm_document.this.arn

  # Task priority
  priority = 1

  task_invocation_parameters {
    automation_parameters {

      # Document version
      document_version = "$DEFAULT"

      # Input parameters
      parameter {
        name   = "InstanceId"
        values = ["{{RESOURCE_ID}}"]
      }
    }
  }

  ## Targets
  # Target by: Selecting registered target groups
  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.this.id]
  }

  ## Rate control
  # Concurrency: 100%
  max_concurrency = 100

  ## Error threshold: 0%
  max_errors = 0

  ## IAM service role
  # Use a custom service role
  service_role_arn = aws_iam_role.this.arn
}
