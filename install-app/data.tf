data "terraform_remote_state" "server" {
  backend = "remote"

  config = {
    organization = "drpebcak"
    workspaces = {
      name = "rancher-as-code_rancher-server"
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "drpebcak"
    workspaces = {
      name = "rancher-as-code_user-cluster"
    }
  }
}
