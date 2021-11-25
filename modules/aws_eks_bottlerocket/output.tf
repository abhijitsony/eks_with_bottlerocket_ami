output "vpc_id" {
  value = aws_vpc.lwcs.id
}
output "private_subnet_id" {
  value = [for az, subnet in aws_subnet.lwcs-private : subnet.id]
}
output "public_subnet_id" {
  value = [for az, subnet in aws_subnet.lwcs-public : subnet.id]
}
output "launch_template_name" {
  value = aws_launch_template.lwcs-bottlerocket_lt.name_prefix
}
output "node_group_name" {
  value = aws_eks_node_group.lwcs-worker-node-group.node_group_name
}
output "worker_desired_size" {
  value = var.worker_desired_size
}
output "worker_max_size" {
  value = var.worker_max_size
}
output "worker_min_size" {
  value = var.worker_min_size
}
output "cluster-name" {
  value = aws_eks_cluster.lwcs-cluster.name
}
output "endpoint" {
  value = aws_eks_cluster.lwcs-cluster.endpoint
}
