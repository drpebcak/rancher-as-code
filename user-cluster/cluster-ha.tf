resource "rancher2_cluster" "user-cluster" {
  name        = "${local.name}"
  description = "Terraform managed RKE cluster"

  rke_config {
    # Shows how easy it is to update
    # kubernetes_version = "v1.13.9-rancher1-2"
    kubernetes_version = "v1.14.5-rancher1-1"
    cloud_provider {
      name = "aws"
    }

    services {
      etcd {
        backup_config {
          enabled        = true
          interval_hours = 6
          retention      = 12

          s3_backup_config {
            access_key  = data.terraform_remote_state.server.outputs.etcd_backup_user_key
            bucket_name = data.terraform_remote_state.server.outputs.etcd_backup_s3_bucket_id
            endpoint    = "s3.us-west-2.amazonaws.com"
            region      = "us-west-2"
            folder      = local.name
            secret_key  = data.terraform_remote_state.server.outputs.etcd_backup_user_secret
          }
        }
      }
    }
  }
}
