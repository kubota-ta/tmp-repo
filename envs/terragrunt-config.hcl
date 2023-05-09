inputs = {
  project = {
    name     = "kubotat"
    region   = "ap-northeast-1"
    key-pair = "keypair-tokyo"
    domain   = {
      main = "kubotat.ii-dev.dmmgames.com"
    }
    aws_profile = "kubotat-terraform"
  }

  requirements = {
    terraform = ">= 1.1.7"
    aws       = ">= 4.11.0"
  }
}

