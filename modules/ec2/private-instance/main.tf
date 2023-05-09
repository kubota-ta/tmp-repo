/**
 * Instance profile
 * 詳細はモジュール参照
 */
module "ec2_role" {
  source = "../../iam/ec2-instance-profile"
  env    = var.env
  name   = var.name
}


## ECS Instance 作成用データの収集

# ユーザーデータ
data "template_file" "user_data" {
  template = file("${path.module}/files/user_data.sh")
  #vars = {
  #  hostname = format("%s-%s", var.env.prefix, var.name)
  #}
}

# デフォルトのAMI
data "aws_ssm_parameter" "ami-latest" {
  # 2022/05 時点で無料枠TOPに出てくる Amazon Linux 2 AMI
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
}

/**
 * EC2 > Instances
 */
resource "aws_instance" "this" {
  count = 1

  ## Choose an Amazon Machine Image (AMI)
  ami = var.ami == null ? data.aws_ssm_parameter.ami-latest.value : var.ami

  ## Choose an Instance Type
  instance_type = var.instance_type

  ## Configure Instance Details
  # Number of instances: 1
  # Purchasing option: Request Spot instances: no

  # Network
  # Subnet
  subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)]

  # Auto-assign Public IP: Use subnet setting

  # Placement group: Add instance to placement group: No
  # Capacity Reservation: Open

  # Domain join directory: No directory

  # IAM role
  iam_instance_profile = module.ec2_role.iam_role.profile

  # Shutdown behavior: stop
  # Stop - Hibernate behavior: Enable hibernation as an additional stop behavior: No

  # Enable termination protection: Protect against accidental termination: No
  disable_api_termination = false

  # Monitoring: No
  monitoring = false

  # Tenancy: Shared
  # Elastic Inference: Add an Elastic Inference accelerator: No

  # Credit specification: Unlimited: No
  credit_specification {
    cpu_credits = "standard"
  }

  # File systems: skip

  ## Advanced Details
  # Enclave: disable
  # Metadata accessible: Eabled
  # Metadata version: V1 and V2
  # Metadata token response hop limit: 1

  # User data
  user_data_base64 = base64encode(data.template_file.user_data.rendered)

  ## Add Storage
  root_block_device {

    # Size
    volume_size = var.volume_size

    # Volume Type
    volume_type = "gp3"

    # Delete on Termination
    delete_on_termination = true

    # Encryption: Not Encryption
  }

  ## Add Tags
  tags = merge(
    {
      Name                 = format("%s-%s", var.env.prefix, var.name)
      SessionManagerAceess = "approval"
    },
    var.env.tags
  )
  volume_tags = merge(
    {
      Name = format("%s-%s", var.env.prefix, var.name)
    },
    var.env.tags
  )

  ## Configure Security Group
  # Assign a security group: Select an existing security group
  vpc_security_group_ids = var.vpc_security_group_ids

  ## Launch
  # assign a key pair
  key_name = var.env.project.key-pair

  #----

  # マネジメントコンソールでは勝手にONになるはず
  ebs_optimized = substr(var.instance_type, 0, 2) == "t2" ? false : true

  lifecycle {
    ignore_changes = [
      # ami-latest を採用した場合に変化をスルーしたい
      ami,
      user_data_base64
    ]
  }
}

