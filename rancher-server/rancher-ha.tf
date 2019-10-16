resource "null_resource" "cert-manager-crds" {
  provisioner "local-exec" {
    command = <<EOF
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/v${var.certmanager_version}/deploy/manifests/00-crds.yaml
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
EOF


    environment = {
      KUBECONFIG = local_file.kube_cluster_yaml.filename
    }
  }
}

# install cert-manager
resource "helm_release" "cert_manager" {
  depends_on = [null_resource.cert-manager-crds]
  version    = "v${var.certmanager_version}"
  name       = "cert-manager"
  chart      = var.certmanager_chart
  namespace  = "cert-manager"

  # Bogus set to link together resources for proper tear down
  set {
    name  = "tf_link"
    value = rke_cluster.rancher_server.api_server_url
  }
}

# install rancher
resource "helm_release" "rancher" {
  name      = "rancher"
  chart     = "v${var.rancher_chart}"
  version   = local.rancher_version
  namespace = "cattle-system"

  set {
    name  = "hostname"
    value = "${local.name}.${local.domain}"
  }

  set {
    name  = "ingress.tls.source"
    value = "letsEncrypt"
  }

  set {
    name  = "letsEncrypt.email"
    value = local.le_email
  }

  set {
    name  = "letsEncrypt.environment"
    value = "production" # valid options are 'staging' or 'production'
  }

  # Bogus set to link togeather resources for proper tear down
  set {
    name  = "tf_link"
    value = helm_release.cert_manager.name
  }
}

resource "null_resource" "wait_for_rancher" {
  provisioner "local-exec" {
    command = <<EOF
while [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; do
    subject=$(curl -vk -m 2 "https://$${RANCHER_HOSTNAME}/ping" 2>&1 | grep "subject:")
    echo "Cert Subject Response: $${subject}"
    if [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; then
      sleep 10
    fi
done
while [ "$${resp}" != "pong" ]; do
    resp=$(curl -sSk -m 2 "https://$${RANCHER_HOSTNAME}/ping")
    echo "Rancher Response: $${resp}"
    if [ "$${resp}" != "pong" ]; then
      sleep 10
    fi
done
EOF


    environment = {
      RANCHER_HOSTNAME = "${local.name}.${local.domain}"
      TF_LINK          = helm_release.rancher.name
    }
  }
}

resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap

  depends_on = [null_resource.wait_for_rancher]

  password = var.rancher_password
}

resource "rancher2_auth_config_github" "github" {
  count         = local.rancher2_auth_config_github_count
  client_id     = var.github_client_id
  client_secret = var.github_client_secret
  access_mode   = "restricted"

  # Concatanate the local Rancher id with any specified GitHub principals
  allowed_principal_ids = concat(["local://${data.rancher2_user.admin.id}"], local.rancher2_auth_github_principal_list)
}
