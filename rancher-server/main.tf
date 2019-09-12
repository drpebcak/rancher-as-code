terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

locals {
  name              = "rancher-demo"
  rancher_version   = "v2.2.8"
  le_email          = "none@none.com"
  domain            = "eng.rancher.space"
  instance_type     = "t3.large"
  master_node_count = 3
  worker_node_count = 3
}

variable "rancher_password" {
  type = string
}
