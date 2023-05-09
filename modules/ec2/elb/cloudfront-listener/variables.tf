variable "env" {
  description = "環境変数"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "health_check" {
  default = {
    protocol            = "HTTP"
    path                = "/healthchecks.html"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 6
    timeout             = 5
    interval            = 10
    matcher             = "200"
  }
}

variable "target_groups" {
  default = {
    #"target-group-name" = {
    #  protocol        = "HTTP"
    #  port            = 80
    #  targets         = [instance_ids]
    #}
  }
}

variable "listener_rules" {
  default = {
    #priority = {
    #  host             = "www.example.com"
    #  x-pre-shared-key = "xxxxxxxx"
    #  target_group     = "target-group-name"
    #}
  }
}

variable "deregist_delay" {
  default = 300
}

variable "load_balancer_arn" {
}

