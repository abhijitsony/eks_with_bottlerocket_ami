resource "local_file" "lwcs-aws_auth_configmap" {
  content         = local.config_map_aws_auth
  filename        = "./modules/aws_eks_bottlerocket/lwcs-config_map_aws_auth.yaml"
  file_permission = "0644"
}

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command     = "kubectl apply -f  $filename  --kubeconfig <(echo $KUBECONFIG | base64 --decode)"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = base64encode(local.awskubeconfig)
      filename   = "./modules/aws_eks_bottlerocket/lwcs-config_map_aws_auth.yaml"
    }
  }
  depends_on = [local_file.lwcs-aws_auth_configmap,
    aws_eks_cluster.lwcs-cluster
  ]
}


resource "local_file" "kubeconfig" {
  content              = local.awskubeconfig
  filename             = "kubeconfig_${aws_eks_cluster.lwcs-cluster.name}"
  file_permission      = "0600"
  directory_permission = "0755"
}
