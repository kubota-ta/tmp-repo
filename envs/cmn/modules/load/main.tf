module "env" {
  source = "../../"
}

data "terraform_remote_state" "this" {
  for_each = toset(var.features)

  backend = "s3"

  config = {
    region  = module.env.project.region
    bucket  = "${module.env.project.name}-tfstate"
    key     = "${module.env.name}/${each.key}.tfstate"
    profile = "${module.env.project.aws_profile}"
  }
}

