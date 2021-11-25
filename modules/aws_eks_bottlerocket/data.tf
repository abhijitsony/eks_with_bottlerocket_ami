data "aws_availability_zones" "available" {}

data "template_file" "lwcs-bottlerocket_config" {
  #template = file("${path.root}/templates/lwcs-bottlerocket_config.toml.tpl")
  template = file("./modules/aws_eks_bottlerocket/templates/lwcs-bottlerocket_config.toml.tpl")
  vars = {
    cluster_name                 = aws_eks_cluster.lwcs-cluster.name
    cluster_endpoint             = aws_eks_cluster.lwcs-cluster.endpoint
    cluster_ca_data              = aws_eks_cluster.lwcs-cluster.certificate_authority[0].data
    node_labels                  = join("\n", [for label, value in local.labels : "\"${label}\" = \"${value}\""])
    node_taints                  = join("\n", [for taint, value in var.taints : "\"${taint}\" = \"${value}\""])
    admin_container_enabled      = true
    admin_container_superpowered = true
    admin_container_source       = var.bottlerocket_admin_source
  }
}

data "aws_ssm_parameter" "lwcs-bottlerocket_image_id" {
  name = "/aws/service/bottlerocket/aws-k8s-${var.eks_version}/x86_64/latest/image_id"
}

data "aws_ami" "lwcs-bottlerocket_image" {
  owners = ["amazon"]
  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.lwcs-bottlerocket_image_id.value]
  }
}

data "aws_vpc" "network" {
  id = aws_vpc.lwcs.id
}

data "aws_subnet_ids" "lwcs-private" {
  vpc_id = aws_vpc.lwcs.id
  tags = {
    "subnet-type" = "private"
  }
  depends_on = [
    aws_subnet.lwcs-private
  ]
}

data "aws_subnet_ids" "lwcs-public" {
  vpc_id = aws_vpc.lwcs.id
  tags = {
    "subnet-type" = "public"
  }
  depends_on = [
    aws_subnet.lwcs-public
  ]
}
