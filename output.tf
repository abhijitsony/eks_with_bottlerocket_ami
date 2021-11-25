output "vpc_id" {
  depends_on = [module.aws_eks_bottlerocket]
  value      = module.aws_eks_bottlerocket.vpc_id
}
output "private_subnet_id" {
  value = [module.aws_eks_bottlerocket.private_subnet_id]
}
output "public_subnet_id" {
  value = [module.aws_eks_bottlerocket.public_subnet_id]
}

output "launch_template_name" {
  value = module.aws_eks_bottlerocket.launch_template_name
}

output "node_group_name" {
  value = module.aws_eks_bottlerocket.node_group_name
}
output "cluster-name" {
  value = module.aws_eks_bottlerocket.cluster-name
}

output "endpoint" {
  value = module.aws_eks_bottlerocket.endpoint
}

