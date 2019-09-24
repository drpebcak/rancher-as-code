output "master-addresses" {
  value = aws_instance.rancher-master.*.public_ip
}

output "worker-addresses" {
  value = aws_instance.rancher-worker.*.public_ip
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

output "etcBackupS3BucketId" {
  value = aws_s3_bucket.etcd-backups.id
}

output "etcBackupUserKey" {
  value     = aws_iam_access_key.etcBackupUser.id
  sensitive = true
}

output "etcBackupUserSecret" {
  value     = aws_iam_access_key.etcBackupUser.secret
  sensitive = true
}
