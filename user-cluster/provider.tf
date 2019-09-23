provider "aws" {
  region = "us-west-2"
  # profile = "rancher-eng"
}

provider "rancher2" {
  api_url   = data.terraform_remote_state.server.outputs.rancher_url
  token_key = data.terraform_remote_state.server.outputs.rancher_token
}
