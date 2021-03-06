output "master_addresses" {
  value = aws_instance.cluster-master.*.public_ip
}

output "worker_addresses" {
  value = aws_instance.cluster-worker.*.public_ip
}

output "cluster_id" {
  value = rancher2_cluster.user-cluster.id
}
