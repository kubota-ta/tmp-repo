# VPC
VPC周りのリソースを作成します。

VPCには /16 のCIDRを指定し、配下に /24 のサブネットを作成します。

以下の4層のサブネットをAZ毎に作成します。
- front
  パブリックIPを持ち、直接アクセス可能なリソースを配置するサブネット
- elb
  ELB専用サブネット
- web
  ELB配下のリソースを配置するサブネット
- private
  バックエンドのリソースを配置するサブネット

## 作られるもの

| ResourceType    | Name                         |
|----             |----                          |
| VPC             | [prefix]-vpc                 |
| Subnet          | [prefix]-subnet-[layer]-[az] |
| InternetGateway | [prefix]-igw-main            |
| EIP+NatGateway  | [prefix]-ngw-[subnet]        |
| RouteTable      | [prefix]-route-[gw]          |
| NetworkACL      | [prefix]-acl                 |

