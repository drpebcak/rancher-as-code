terraform {
  backend "remote" {
    organization = "drpebcak"
    workspaces {
      name = "rancher-as-code_user-cluster"
    }
  }
}

locals {
  name              = "cluster-demo"
  rancher_version   = "v2.2.8"
  instance_type     = "t3.large"
  master_node_count = 3
  worker_node_count = 3
}
