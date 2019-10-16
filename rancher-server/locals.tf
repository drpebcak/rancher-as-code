locals {
  name              = var.name
  rancher_version   = var.rancher_version
  le_email          = var.le_email
  domain            = var.domain
  r53_domain        = length(var.r53_domain) > 0 ? var.r53_domain : local.domain
  instance_type     = var.instance_type
  master_node_count = var.master_node_count
  worker_node_count = var.worker_node_count

  rancher2_auth_config_github_count   = var.rancher2_github_auth_enabled ? 1 : 0
  rancher2_auth_github_user           = length(var.rancher2_github_auth_user) > 0 ? [var.rancher2_github_auth_user] : []
  rancher2_auth_github_org            = length(var.rancher2_github_auth_org) > 0 ? [var.rancher2_github_auth_org] : []
  rancher2_auth_github_team           = length(var.rancher2_github_auth_team) > 0 ? [var.rancher2_github_auth_team] : []
  rancher2_auth_github_principal_list = concat(local.rancher2_auth_github_user, local.rancher2_auth_github_org, local.rancher2_auth_github_team)

  # Default to main aws region for backups unless overridden
  rke_backup_region = length(var.rke_backups_region) > 0 ? var.rke_backups_region : var.aws_region
  # Default to S3 endpoint for region unless overridden
  rke_backup_endpoint = length(var.rke_backups_s3_endpoint) > 0 ? var.rke_backups_s3_endpoint : "s3.${local.rke_backup_region}.amazonaws.com"

  # If not using default vpc in region, use vpc_id passed in
  vpc_id             = data.aws_vpc.default.id
  aws_elb_subnet_ids = length(var.aws_elb_subnet_ids) > 0 ? var.aws_elb_subnet_ids : data.aws_subnet_ids.available.ids

  rancher2_master_subnet_ids = length(var.rancher2_master_subnet_ids) > 0 ? var.rancher2_master_subnet_ids : data.aws_subnet_ids.available.ids
  rancher2_worker_subnet_ids = length(var.rancher2_worker_subnet_ids) > 0 ? var.rancher2_worker_subnet_ids : data.aws_subnet_ids.available.ids

  use_asgs_for_rancher_infra = true
}
