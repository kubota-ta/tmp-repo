### タスクロール/タスク実行ロール -----------------------------------------------------------------
# 詳細はモジュール参照

module "ecs_role" {
  source = "../../iam/ecs-task-role"

  env  = var.env
  name = var.name

  task_role_policy_arns      = var.task_role_policy_arns
  task_exec_role_policy_arns = var.task_exec_role_policy_arns
}


### ローカル変数 ----------------------------------------------------------------------------------

locals {
  # カーネルチューニングのパラメータ
  kernel_tuning = {
    "net.ipv4.tcp_tw_reuse"         = "1"
    "net.ipv4.tcp_fin_timeout"      = "10"
    "net.ipv4.tcp_max_syn_backlog"  = "4096"
    "net.core.somaxconn"            = "4096"
    "net.ipv4.tcp_keepalive_intvl"  = "3"
    "net.ipv4.tcp_keepalive_probes" = "2"
    "net.ipv4.tcp_keepalive_time"   = "10"
  }

  # コンテナ定義
  container_definitions = [
    for container in var.container_definitions : {
      name  = container.name
      image = container.image

      portMappings = length(try(container.portMappings, {})) > 0 ? [
        for port in container.portMappings : {
          containerPort = port.containerPort
          hostPort      = port.hostPort
          protocol      = "tcp"
        }
      ] : null

      healthCheck = length(try(container.healthCheck, {})) > 0 ? {
        command     = container.healthCheck
        interval    = 10
        retries     = 6
        startPeriod = 60
        timeout     = 5
      } : null

      environment = length(try(container.environment, {})) > 0 ? [
        for k, v in container.environment : {
          name  = k
          value = v
        }
      ] : null

      secrets = length(try(container.secrets, {})) > 0 ? [
        for k, v in container.secrets : {
          name      = k
          valueFrom = v
        }
      ] : null

      dependsOn = length(try(container.dependsOn, {})) > 0 ? [
        for k, v in container.dependsOn : {
          containerName = k
          condition     = v
        }
      ] : null

      systemControls = [
        for k, v in local.kernel_tuning : {
          namespace = k
          value     = v
        }
      ]

      logConfiguration = length(try(container.logConfiguration, {})) > 0 ? {
        logDriver = container.logConfiguration.logDriver
        options   = container.logConfiguration.options
      } : null

      firelensConfiguration = length(try(container.firelensConfiguration, {})) > 0 ? {
        type    = container.firelensConfiguration.type
        options = container.firelensConfiguration.options
      } : null

      links = length(try(container.links, {})) > 0 ? container.links : null

      # デフォルト値
      cpu         = 0
      essential   = true
      mountPoints = []
      volumesFrom = []
    }
  ]
}


### タスク定義 ------------------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition

resource "aws_ecs_task_definition" "this" {

  ## Task Definition
  # Task definition name: xxx-env-example-task-def
  family = format("%s-%s-task-def", var.env.prefix, var.name)

  # Requires compatibilities: EC2
  requires_compatibilities = []

  # Task role: xxx-env-example-task-role
  task_role_arn = module.ecs_role.task.arn

  # Network mode: <default>


  ## Task execution IAM role
  # Task execution role: xxx-env-example-taskexec-role
  execution_role_arn = module.ecs_role.task_exec.arn


  ## Task size
  # Task memory (MiB): 0
  memory = 0

  # Task CPU (unit): --

  ## Container definitions
  # Add container
  container_definitions = jsonencode(
    local.container_definitions,
  )


  ## Tags
  tags = var.env.tags
}


### ECSクラスター ---------------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster

resource "aws_ecs_cluster" "this" {

  ## Configure cluster
  # Cluster name: xxx-env-example-cluster
  name = format("%s-%s-cluster01", var.env.prefix, var.name)


  ## CloudWatch Container Insights
  # CloudWatch Container Insights: disable
  setting {
    name  = "containerInsights"
    value = var.container_insights == true ? "enabled" : "disabled"
  }


  ## Tags
  tags = var.env.tags
}


### サービス定義 ----------------------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service

resource "aws_ecs_service" "this" {

  ## Configure service
  # Launch type:

  # Task Definition:
  task_definition = aws_ecs_task_definition.this.arn

  # Cluster:
  cluster = aws_ecs_cluster.this.id

  # Service name:
  name = format("%s-%s-service01", var.env.prefix, var.name)

  # Service type:
  scheduling_strategy = var.scheduling_strategy

  # Number of tasks
  desired_count = var.scheduling_strategy == "DAEMON" ? null : var.desired_count

  # Minimum healthy percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  # Maximum percent
  deployment_maximum_percent = var.deployment_maximum_percent
  #deployment_maximum_percent = var.scheduling_strategy == "DAEMON" ? 100 : var.deployment_maximum_percent

  # Deployment circuit breaker: Disabled


  ## Deployments
  # Deployment type: Rolling update


  ## Task Placement
  # Placement Templates: Custom

  ## Task tagging configuration
  # Enable ECS managed tags: No
  # Propagate tags from: Do not propagate

  ## Tags
  tags = var.env.tags


  ## Configure network
  # Health check grace period: 300
  health_check_grace_period_seconds = var.target_group_arn != null ? var.health_check_grace_period_seconds : null

  # Load balancer type:

  # Service IAM role:

  # Load balancer name:


  ## Container to load balance
  # Container name : port
  dynamic "load_balancer" {
    for_each = var.target_group_arn != null ? [1] : [0]

    content {
      container_name   = var.container_name
      container_port   = var.container_port
      target_group_arn = var.target_group_arn
    }
  }


  ## Service discovery (optional)
  # Enable service discovery integration: No


  ## Set Auto Scaling (optional)
  # Service Auto Scaling: Daemon services are not compatible with Auto Scaling.
}
