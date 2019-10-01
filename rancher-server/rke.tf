############################
### RKE Cluster
###########################
resource "rke_cluster" "rancher_server" {
  depends_on = [null_resource.wait_for_docker]

  dynamic nodes {
    for_each = aws_instance.rancher_master
    content {
      address          = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      user             = var.instance_ssh_user
      role             = ["controlplane", "etcd"]
      ssh_key          = tls_private_key.ssh.private_key_pem
    }
  }

  dynamic nodes {
    for_each = aws_instance.rancher_worker
    content {
      address          = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      user             = var.instance_ssh_user
      role             = ["worker"]
      ssh_key          = tls_private_key.ssh.private_key_pem
    }
  }

  cluster_name = "rancher-management"
  addons       = file("${path.module}/files/addons.yaml")

  services_etcd {
    # for etcd snapshots
    backup_config {
      interval_hours = 12
      retention      = 6
      # s3 specific parameters
      s3_backup_config {
        access_key  = aws_iam_access_key.etcd_backup_user.id
        secret_key  = aws_iam_access_key.etcd_backup_user.secret
        bucket_name = aws_s3_bucket.etcd_backups.id
        region      = local.rke_backup_region
        folder      = local.name
        endpoint    = local.rke_backup_endpoint
      }
    }
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/outputs/kube_config_cluster.yml"
  content  = rke_cluster.rancher_server.kube_config_yaml
}
