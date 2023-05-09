# Security group: 自己参照グループ
module "sg-self" {
  for_each = toset([
    "elb",
  ])
  source = "../../../modules/ec2/security-group/self"
  env    = module.env
  vpc_id = module.env.cmn.vpc.vpc_id
  name   = each.key
}
