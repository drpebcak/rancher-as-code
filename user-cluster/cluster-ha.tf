resource "rancher2_cluster" "user-cluster" {
  name        = "${local.name}"
  description = "Terraform managed RKE cluster"

  rke_config {
    # Shows how easy it is to update
    kubernetes_version = "v1.13.9-rancher1-2"
    # kubernetes_version = "v1.14.5-rancher1-1"
    cloud_provider {
      name = "aws"
    }
  }
}
