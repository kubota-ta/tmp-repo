/**
 * EC2 > Load Balancers
 */
resource "aws_lb" "this" {
  # Select load balancer type: Application Load Balancer
  load_balancer_type = "application"

  # Name
  name = "${var.env.prefix}-${var.name}"

  # Scheme: internet-facing
  internal = false

  # IP address type
  ip_address_type = "ipv4"

  # Listeners: HTTP:80 or HTTPS:443  -- terraform では別途設定（listener 作成時）

  # Availability Zones
  subnets = var.subnets

  # Add-on services
  # AWS Global Accelerator: No

  # Tags
  tags = merge(
    { Name = "${var.env.prefix}-${var.name}" },
    var.env.tags
  )

  ## Configure Security Settings (HTTPSの場合のみ)  -- terraform では別途設定（listener 作成時）
  # Certificate type: Choose a certificate from ACM
  # Certificate name: xxx
  # Security policy: ELBSecurityPolicy-2016-08

  ## Configure Security Groups: Select an existing security group
  security_groups = var.security_groups

  ## Configure Routing
  # Target group:  -- terraform では別途設定（target group 作成時）

  /**
   * Load Balancers > [Created Load Balancer] > [Edit attributes]
   */
  ## Idle timeout
  idle_timeout = var.idle_timeout

  ## Access logs
  dynamic "access_logs" {
    for_each = var.log_bucket != null ? [1] : []
    content {
      # Enable: Yes
      enabled = true

      # S3 location: s3://bucketname/path/to/log/prefix
      bucket = var.log_bucket
      prefix = "elb/${var.env.prefix}-${var.name}"

      # Create this location for me: No
    }
  }
}

