provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias = "r53"
}

provider "rke" {
}

provider "helm" {
  install_tiller  = true
  namespace       = "kube-system"
  service_account = "tiller"

  kubernetes {
    config_path = local_file.kube_cluster_yaml.filename
  }
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${local.name}.${local.domain}"
  bootstrap = true
}

provider "rancher2" {
  api_url   = "https://${local.name}.${local.domain}"
  token_key = rancher2_bootstrap.admin.token
}
