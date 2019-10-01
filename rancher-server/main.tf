terraform {
  backend "remote" {
    organization = "drpebcak"
    workspaces {
      name = "rancher-as-code_rancher-server"
    }
  }
}
