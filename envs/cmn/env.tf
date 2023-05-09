/**
 * 環境定義
 */

output "name" {
  description = "環境名"
  value       = local.env
}

output "project" {
  description = "プロジェクト定義"
  value       = module.project
}

output "tags" {
  description = "作成したリソースに共通して付与するタグ"
  value = merge(
    {
      Env = local.env
    },
    module.project.tags
  )
}

output "prefix" {
  description = "リソース名の接頭文字列"
  value       = format("%s-%s", module.project.name, local.env)
}

/**
 * ローカル処理
 */
module "project" {
  source = "../"
}
locals {
  #ディレクトリ名を名乗る
  env = basename(abspath(path.module))
}

