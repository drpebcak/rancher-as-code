data "terraform_remote_state" "server" {
  backend = "local"

  config = {
    path = "${path.module}/../rancher-server/rancher.tfstate"
  }
}

data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "${path.module}/../user-cluster/user-cluster.tfstate"
  }
}
