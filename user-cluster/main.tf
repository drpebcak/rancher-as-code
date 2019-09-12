terraform {
  backend "local" {
    path = "user-cluster.tfstate"
  }
}

locals {
  name              = "cluster-demo"
  rancher_version   = "v2.2.8"
  instance_type     = "t3.large"
  master_node_count = 3
  worker_node_count = 3
}
