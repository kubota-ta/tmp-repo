variable "public_subnets" {
  description = "パブリックリソース用サブネットと識別番号(0-9)"
  #識別番号は全体で重複しない
  default = {
    front = 0,
    elb   = 1,
    #web     = 2,
    #private = 3,
  }
}

variable "private_subnets" {
  description = "プライベートリソース用サブネットと識別番号(0-9)"
  #識別番号は全体で重複しない
  default = {
    #front   = 0,
    #elb     = 1,
    web     = 2,
    private = 3,
  }
}

variable "subnets" {
  description = "サブネット構成"
  default = {
    ap-northeast-1 = {
      region = "ap-northeast-1"

      # ゾーンと識別番号(1-25)
      zones = {
        a = 1,
        #b =  ,
        c = 2,
        d = 3,
      }

      # デフォルトゲートウェイ割り当て
      gw = {
        # public subnets
        front-a = { igw = "main" }
        front-c = { igw = "main" }
        front-d = { igw = "main" }
        elb-a   = { igw = "main" }
        elb-c   = { igw = "main" }
        elb-d   = { igw = "main" }

        # private subnets
        # 理想はAZ毎にゲートウェイ作成ですが、節約して2台に分配
        web-a     = { ngw = "front-a" }
        web-c     = { ngw = "front-c" }
        web-d     = { ngw = "front-a" }
        private-a = { ngw = "front-a" }
        private-c = { ngw = "front-c" }
        private-d = { ngw = "front-a" }
      }
    }

    us-east-1 = {
      region = "us-east-1"

      zones = {
        a = 1,
        b = 2,
        c = 3,
        d = 4,
        e = 5,
        f = 6,
      }

      gw = {}

    }
  }
}
