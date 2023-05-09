/**
 * Target group
 */
resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  ## Basic configuration
  # Choose a target type: Instances

  # Target group name
  name = format("%s-%s", var.env.prefix, each.key)

  # Protocol
  protocol = each.value.protocol

  # Port
  port = each.value.port

  # VPC
  vpc_id = var.vpc_id

  # Protocol version
  protocol_version = "HTTP1"

  ## Health checks
  dynamic "health_check" {
    for_each = {
      this = lookup(each.value, "health_check", var.health_check)
    }

    content {
      # Health check protocol
      protocol = health_check.value.protocol

      # Health check path
      path = health_check.value.path

      ## Advanced health check settings
      # Port: Traffic port
      port = health_check.value.port

      # Healthy threshold
      healthy_threshold = health_check.value.healthy_threshold

      # Unhealthy threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold

      # Timeout
      timeout = health_check.value.timeout

      # Interval
      interval = health_check.value.interval

      # Success codes
      matcher = health_check.value.matcher
    }
  }
   #　切り離し時間
  deregistration_delay = var.deregist_delay

  ## Tags
  tags = var.env.tags

  ## Register targets
  # later
}

/**
 * Target groups > [Created target group]
 * Register targets
 */
resource "aws_lb_target_group_attachment" "this" {
  for_each = merge([
    for k, tg in var.target_groups : {
      for i, v in tg.targets : "${k}_${i}" => { k = k, v = v }
    }
  ]...)
  target_group_arn = aws_lb_target_group.this[each.value.k].arn
  target_id        = each.value.v
  port             = var.target_groups[each.value.k].port
}

/**
 * Load balancers > [Load balancer] > Listeners
 * Add listener
 */
resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer_arn

  # Protocol : port
  protocol = "HTTP"
  port     = "80"

  # Default action
  default_action {

    # Return fixed response...
    type = "fixed-response"

    fixed_response {

      # Response code
      status_code = "403"

      # Content-Type
      content_type = "text/plain"

      # Response body
      message_body = "403 Forbidden"
    }
  }
}

/**
 * Load balancers > [Load balancer] > Listeners > [Created Lisner]
 * View/edit rules > +
 */
resource "aws_lb_listener_rule" "this" {
  for_each = var.listener_rules

  listener_arn = aws_lb_listener.this.arn
  priority     = each.key

  # Add condition
  condition {
    # Host header...
    host_header {
      values = [each.value.host]
    }
  }

  # Add condition
  condition {
    # Http header...
    http_header {
      http_header_name = "x-pre-shared-key"
      values           = [each.value.x-pre-shared-key]
    }
  }

  # Add action
  action {
    # Forward to...
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group].arn
  }
}

