data "aws_instance" "origin" {
  instance_id = var.origin_id
}

data "aws_ami_ids" "this" {
  owners     = ["self"]
  name_regex = "^${data.aws_instance.origin.tags.Name}_"
  filter {
    name   = "tag:TerraformAMIIndex"
    values = ["*"]
  }
}

data "aws_ami" "this" {
  count  = length(data.aws_ami_ids.this.ids)
  owners = ["self"]
  filter {
    name   = "image-id"
    values = [data.aws_ami_ids.this.ids[count.index]]
  }
}

locals {
  ami_list = {
    for k, v in data.aws_ami.this :
    v.tags.TerraformAMIIndex => v.tags.Name if v.tags.TerraformAMIIndex > var.ami_index - var.ami_retention
  }
  ami_new_suffix = formatdate("YYYYMMDD-hhmm", timestamp())
  ami_latest     = lookup(local.ami_list, var.ami_index, "${data.aws_instance.origin.tags.Name}_${local.ami_new_suffix}")
}

resource "aws_ami_from_instance" "this" {
  for_each           = merge(local.ami_list, { (var.ami_index) = local.ami_latest })
  name               = each.value
  source_instance_id = var.origin_id
  tags = merge(
    var.env.tags,
    {
      Name              = each.value
      TerraformAMIIndex = each.key
    }
  )
}
