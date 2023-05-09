resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = var.scope

  dynamic "rule" {
    for_each = var.rules

    content {
      name = rule.key

      priority = index(var.rule_priority, rule.key)

      statement {
        ip_set_reference_statement {
          arn = rule.value.ip_set
        }
      }

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics[rule.key].enabled
        metric_name                = var.cloudwatch_metrics[rule.key].metric_name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  visibility_config {
    # GUI操作でOFFできなかったのでとりあえずON固定
    cloudwatch_metrics_enabled = true
    metric_name                = var.name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  /*
  # TBD: CloudWatch ON/OFF はとりあえずデフォルトOFF->手動ON
  # visibility_config の差分を無視したい時に一時的にlifecycle.ignore_changesのコメントアウトを外す
  # rule.visibility_config をうまく指定できず rule まるごと指定なので注意
  # terraform を動かすときは visibility_config を戻す方かデフォルト変更を検討するのがいいです
  lifecycle {
    ignore_changes = [ visibility_config, rule ]
  }
*/
}
