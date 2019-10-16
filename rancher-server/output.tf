output "master_addresses" {
  value       = aws_instance.rancher_master.*.public_ip
  description = "IP addresses of Rancher master nodes"
}

output "worker_addresses" {
  value       = aws_instance.rancher_worker.*.public_ip
  description = "IP addresses of Rancher worker nodes"
}

output "rancher_admin_password" {
  value       = var.rancher_password
  sensitive   = true
  description = "Password set for Rancher local admin user"
}

output "rancher_url" {
  value       = rancher2_bootstrap.admin.url
  description = "URL at which to reach Rancher"
}

output "rancher_token" {
  value       = rancher2_bootstrap.admin.token
  sensitive   = true
  description = "Admin token for Rancher cluster use"
}

output "etcd_backup_s3_bucket_id" {
  value       = aws_s3_bucket.etcd_backups.id
  description = "S3 bucket ID for etcd backups"
}

output "etcd_backup_user_key" {
  value       = aws_iam_access_key.etcd_backup_user.id
  sensitive   = true
  description = "AWS IAM access key id for etcd backup user"
}

output "etcd_backup_user_secret" {
  value       = aws_iam_access_key.etcd_backup_user.secret
  sensitive   = true
  description = "AWS IAM secret access key for etcd backup user"
}
