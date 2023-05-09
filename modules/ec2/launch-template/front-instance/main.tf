## Latest Amazon Linux 2
data "aws_ssm_parameter" "ami_amzn2_latest" {
  # 2022/05 時点で無料枠TOPに出てくる Amazon Linux 2 AMI
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
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
  description = (
    var.description == null
    ? "EC2 launch template for ${var.env.prefix}-${var.name}"
    : var.description
  )

  # Template tags
  tags = var.env.tags

  # Source template: na

  ## Amazon machine image (AMI)

  # AMI
  image_id = var.image_id == null ? data.aws_ssm_parameter.ami_amzn2_latest.value : var.image_id

  ## Instance type

  # Instance type
  instance_type = var.instance_type

  ## Key pair (login)

  # Key pair name
  key_name = var.env.project.key-pair

  ## Network settings
  network_interfaces {

    # Subnet:
    subnet_id = var.subnet_id

    # Security groups
    security_groups = var.security_groups

    # Advanced network configuration
    # Device index
    device_index = 0

    # Description
    description = "primary-eni"

    # Auto-assign public IP
    associate_public_ip_address = true
  }

  ## Configure storage: na

  ## Resource tags:
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

  ## Advanced details

  # IAM instance profile
  iam_instance_profile {
    arn = var.iam_instance_profile
  }

  # EBS-optimized instance
  ebs_optimized = true

  # User data
  user_data = var.user_data
}
