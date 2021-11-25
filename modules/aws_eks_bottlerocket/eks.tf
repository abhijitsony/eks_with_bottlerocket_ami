resource "aws_security_group" "lwcs-control_plane" {
  count = var.legacy_security_groups ? 1 : 0

  name        = "eks-control-plane-${var.name}"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.lwcs.id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #cidr_blocks = [cidrsubnet(var.cidr_block, 8, count.index), cidrsubnet(var.cidr_block, 20, count.index), var.personal_ip]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-control-plane-${var.name}"
  }
}

resource "aws_eks_cluster" "lwcs-cluster" {
  enabled_cluster_log_types = []
  name                      = "${var.name}"
  role_arn                  = aws_iam_role.lwcs-cluster_role.arn
  version                   = var.eks_version
  vpc_config {
    subnet_ids              = concat(sort(data.aws_subnet_ids.lwcs-private.ids), sort(data.aws_subnet_ids.lwcs-public.ids))
    security_group_ids      = aws_security_group.lwcs-control_plane.*.id
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }
  tags = var.tags
  depends_on = [
    aws_iam_role.lwcs-cluster_role,
    aws_iam_role.lwcs-managed_workers,
    aws_cloudwatch_log_group.lwcs-cluster,
    aws_nat_gateway.lwcs_network_nat_gateway
  ]

  provisioner "local-exec" {
    command     = "until curl --output /dev/null --insecure --silent ${self.endpoint}/healthz; do sleep 1; done"
    working_dir = path.module
  }

}
resource "aws_cloudwatch_log_group" "lwcs-cluster" {
  name              = "/aws/eks/${var.name}/cluster"
  retention_in_days = var.log_retention
}
