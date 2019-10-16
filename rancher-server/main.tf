terraform {
  backend "remote" {
    organization = "drpebcak"
    workspaces {
      name = "rancher-as-code_rancher-server"
    }
  }

  required_providers {
    rancher2 = "> 0.0.0"
  }
}
