data "terraform_remote_state" "server" {
  backend = "local"

  config = {
    path = "${path.module}/../rancher-server/rancher.tfstate"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "available" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "template_file" "worker-user_data" {
  template = file("${path.module}/files/cloud-config.yaml")
  vars = {
    registration_command = "${rancher2_cluster.user-cluster.cluster_registration_token[0]["node_command"]} --worker"
  }
  depends_on = [rancher2_cluster.user-cluster]
}

data "template_file" "master-user_data" {
  template = file("${path.module}/files/cloud-config.yaml")
  vars = {
    registration_command = "${rancher2_cluster.user-cluster.cluster_registration_token[0]["node_command"]} --etcd --controlplane"
  }
  depends_on = [rancher2_cluster.user-cluster]
}
