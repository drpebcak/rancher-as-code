output "master-addresses" {
  value = aws_instance.rancher-master.*.public_ip
}

output "worker-addresses" {
  value = aws_instance.rancher-worker.*.public_ip
}

output "rancher_admin_password" {
  value = var.rancher_password
}

output "rancher_url" {
  value = rancher2_bootstrap.admin.url
}

output "rancher_token" {
  value     = rancher2_bootstrap.admin.token
  sensitive = true
}
