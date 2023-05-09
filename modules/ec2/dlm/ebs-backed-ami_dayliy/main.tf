/**
 * EC2 > Lifecycle Manager > [Create lifecycle policy]
 */
resource "aws_dlm_lifecycle_policy" "this" {

  policy_details {
    ## Select policy type
    # Policy types: EBS-backed AMI policy
    resource_types = ["INSTANCE"]
    policy_type    = "IMAGE_MANAGEMENT"

    ## Specify settings
    # Target resource tags
    target_tags = var.target_tags

    # Policy description
    #description = (後ほどセクション外で設定)

    # IAM role: Choose another role
    #execution_role_arn = (後ほどセクション外で設定)

    # Tags
    #tags = (後ほどセクション外で設定)

    # Policy status: Enabled
    #state = (後ほどセクション外で設定)

    # Instance reboot
    parameters {
      no_reboot = var.reboot == true ? false : true
    }

    ## Configure schedule 1 - Schedule 1
    schedule {
      # Schedule name
      name = "daily"

      create_rule {
        # Frequency: Daily
        # Every: 24 hours
        # Starting at: xx:xxUTC
        interval      = 24
        interval_unit = "HOURS"
        times         = [var.starting_at]
      }

      retain_rule {
        # Retention type: Count
        # Keep: n AMIs
        count = var.retention_count
      }

      ## Advanced settings
      # Copy tags from source: Yes
      copy_tags = true

      # Variable tags: instance-id:$(instance-id)
      variable_tags = {
        instance-id = "$(instance-id)"
      }

      # Enable AMI deprecation for this schedule: No

      # Enable cross-Region copy for this schedule: No
    }
  }

  ##--
  description        = var.description
  execution_role_arn = var.iam_role
  tags = merge(
    { Name = format("%s-%s", var.env.prefix, var.name) },
    var.env.tags
  )
  state = "ENABLED"
}
