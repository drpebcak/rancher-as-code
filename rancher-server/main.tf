terraform {
  backend "remote" {
    organization = "drpebcak"
    workspaces {
      name = "rancher-as-code_rancher-server"
    }
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

variable "github_client_id" {
  type = string
}

variable "github_client_secret" {
  type = string
}
