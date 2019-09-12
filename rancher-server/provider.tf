provider "aws" {
  region  = "us-west-2"
  profile = "rancher-eng"
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
