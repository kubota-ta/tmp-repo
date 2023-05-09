data "aws_instance" "this" {
  instance_id = var.instance_id
}

/**
 * EC2 > Volumes > [Create Volume]
 */
resource "aws_ebs_volume" "this" {

  # Volume Type
  type = "gp3"

  # Size (GiB)
  size = var.size

  # IOPS
  iops = 3000

  # Throughput (MB/s)
  throughput = 125

  # Availability Zone
  availability_zone = data.aws_instance.this.availability_zone

  # Snapshot ID: na

  # Encryption: No

  # Tag
  tags = merge(
    var.env.tags,
    { Name = "${data.aws_instance.this.tags.Name}-${var.name}" }
  )
}

/**
 * Volumes > [Created Volume] > Attach Volume
 */
resource "aws_volume_attachment" "this" {

  # Volume
  volume_id = aws_ebs_volume.this.id

  # Instance
  instance_id = data.aws_instance.this.id

  # Device
  device_name = var.device_name

}

