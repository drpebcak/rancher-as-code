locals {
  name              = "rancher-demo"
  rancher_version   = "v2.2.8"
  le_email          = var.le_email
  domain            = var.domain
  instance_type     = var.instance_type
  master_node_count = var.master_node_count
  worker_node_count = var.worker_node_count

  rancher2_auth_config_github_count   = var.rancher_github_auth_enabled ? 1 : 0
}
