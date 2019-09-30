locals {
  name              = "rancher-demo"
  rancher_version   = "v2.2.8"
  le_email          = var.le_email
  domain            = var.domain
  instance_type     = var.instance_type
  master_node_count = var.master_node_count
  worker_node_count = var.worker_node_count

  rancher2_auth_config_github_count   = var.rancher_github_auth_enabled ? 1 : 0
  rancher2_auth_github_user           = len(var.rancher_github_auth_user) > 0 ? [var.rancher_github_auth_user] : []
  rancher2_auth_github_org            = len(var.rancher_github_auth_org) > 0 ? [var.rancher_github_auth_org] : []
  rancher2_auth_github_team           = len(var.rancher_github_auth_team) > 0 ? [var.rancher_github_auth_team] : []
  rancher2_auth_github_principal_list = concat(local.rancher2_auth_github_user, local.rancher2_auth_github_org, local.rancher2_auth_github_team)
}
