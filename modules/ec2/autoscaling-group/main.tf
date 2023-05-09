/**
 * AMI 作成
 */
module "ami" {
  count         = var.origin_id == null ? 0 : 1
  source        = "../../../modules/ec2/ami/retention"
  env           = var.env
  origin_id     = var.origin_id
  ami_retention = var.ami_retention
  ami_index     = var.ami_index
}

/**
 * EC2 > Launch templates > Create launch template
 */
resource "aws_launch_template" "this" {
  update_default_version = var.default_version == 0 ? true : null
  default_version        = var.default_version > 0 ? var.default_version : null


  ## Launch template name and description

  # Launch template name
  name = "${var.env.prefix}-${var.name}"

  # Template version description
  description = "EC2 launch template for AutoScaling"

  # Template tags
  tags = var.env.tags

  # Source template: na

  ## Amazon machine image (AMI)

  # AMI
  image_id = module.ami == [] ? var.image_id : module.ami[0].image_id

  ## Instance type

  # Instance type
  instance_type = var.instance_type

  ## Key pair (login)

  # Key pair name
  key_name = var.env.project.key-pair

  ## Network settings

  # Networking platform: Virtual Private Cloud (VPC)

  # Security groups
  vpc_security_group_ids = var.security_groups

  ## Storage (volumes): na

  ## Resource tags: na
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      { LaunchTemplate = "${var.env.prefix}-${var.name}",
      SessionManagerAceess = "approval" },
      { for k, v in var.env.tags : k => v if k != "Terraform" }
    )
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      { LaunchTemplate = "${var.env.prefix}-${var.name}" },
      { for k, v in var.env.tags : k => v if k != "Terraform" }
    )
  }

  ## Network interfaces: na

  ## Advanced details

  # IAM instance profile
  iam_instance_profile {
    arn = var.iam_instance_profile
  }

  # Credit specification
  dynamic "credit_specification" {
    for_each = substr(var.instance_type, 0, 1) == "t" ? [1] : []
    content {
      cpu_credits = "standard"
    }
  }

  # EBS-optimized instance
  ebs_optimized = true

  # User data
  user_data = var.user_data
}

/**
 * EC2 > Auto Scaling groups > Create Auto Scaling group
 */
resource "aws_autoscaling_group" "this" {
  ## Name

  # Auto Scaling group name
  name = "${var.env.prefix}-${var.name}"

  ## Launch template
  launch_template {

    # Launch template
    id = aws_launch_template.this.id

    # Version
    version = "$Default"
  }

  ## Instance purchase options: Adhere to launch template

  ## Network

  # VPC

  # Subnets
  vpc_zone_identifier = var.subnet_ids

  ## Load balancing

  # Attach to an existing load balancer
  # Choose from your load balancer target groups
  # Existing load balancer target groups
  target_group_arns = var.target_group_arns

  ## Health checks

  # ELB: Yes
  health_check_type = "ELB"

  # Health check grace period: 300 sec

  ## Additional settings

  # Enable group metrics collection within CloudWatch: No

  ## Group size

  # Desired capacity
  desired_capacity = var.desired_capacity

  # Minimum capacity
  min_size = var.min_size

  # Maximum capacity
  max_size = var.max_size

  ## Scaling policies

  # None

  # Target tracking scaling policy
  # Scaling policy name: Target Tracking Policy
  # Metric type: Average CPU utilization
  # Target value: 50
  # Instances need: 300 seconds warm up before including in metric
  # Disable scale in to create only a scale-out policy: No

  ## Instance scale-in protection

  # Enable instance scale-in protection: No

  ## Add notifications

  ## Add tags
  dynamic "tag" {
    for_each = merge(
      { "Name" = "${var.env.prefix}-${var.name}-AUTOSCALE" },
      var.env.tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = tag.key == "Terraform" ? false : true
    }
  }
}
