output "master-addresses" {
  value = aws_instance.cluster-master.*.public_ip
}

output "worker-addresses" {
  value = aws_instance.cluster-worker.*.public_ip
}
