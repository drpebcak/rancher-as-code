terraform {
  backend "local" {
    path = "install-app.tfstate"
  }
}

resource "rancher2_catalog" "demo" {
  name        = "rio-catalog"
  url         = "https://github.com/drpebcak/rancher-as-code.git"
  branch      = "master"
  description = "Rancher-style helm repository with charts for installing Rio"
}

data "rancher2_project" "system" {
  cluster_id = data.terraform_remote_state.cluster.outputs.cluster_id
  name       = "System"
}

resource "rancher2_namespace" "rio-system" {
  name        = "rio-system"
  description = "Namespace for Rio components"
  project_id  = data.rancher2_project.system.id
}

resource "rancher2_app" "rio" {
  catalog_name     = "rio-catalog"
  name             = "rio"
  project_id       = data.rancher2_project.system.id
  target_namespace = rancher2_namespace.rio-system.name
  template_name    = "rio"
  template_version = "0.0.1"
  depends_on       = [rancher2_catalog.demo]
}
