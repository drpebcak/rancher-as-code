output "master_addresses" {
  value = aws_instance.rancher_master.*.public_ip
}

output "worker_addresses" {
  value = aws_instance.rancher_worker.*.public_ip
}

output "rancher_admin_password" {
  value     = var.rancher_password
  sensitive = true
}

output "rancher_url" {
  value = rancher2_bootstrap.admin.url
}

output "rancher_token" {
  value     = rancher2_bootstrap.admin.token
  sensitive = true
}

output "etcd_backup_s3_bucket_id" {
  value = aws_s3_bucket.etcd_backups.id
}

output "etcd_backup_user_key" {
  value     = aws_iam_access_key.etcd_backup_user.id
  sensitive = true
}

output "etcd_backup_user_secret" {
  value     = aws_iam_access_key.etcd_backup_user.secret
  sensitive = true
}
