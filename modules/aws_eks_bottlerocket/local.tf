locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapUsers: |
    - userarn: ${var.cs_user_aws_arn}
      username: ${var.cs_user_aws_username}
      groups:
        - system:masters
        - system:bootstrappers
        - system:nodes
  mapRoles: |
    - rolearn: ${aws_iam_role.lwcs-managed_workers.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:masters
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::807828924102:role/lacework-cs2-admin-role
      username: lacework-cs2-admin-role
      groups:
        - system:masters
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  awskubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.lwcs-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.lwcs-cluster.certificate_authority[0].data}
  name: ${aws_eks_cluster.lwcs-cluster.name}
contexts:
- context:
    cluster: ${aws_eks_cluster.lwcs-cluster.name}
    user: ${aws_eks_cluster.lwcs-cluster.name}
  name: ${aws_eks_cluster.lwcs-cluster.name}
current-context: ${aws_eks_cluster.lwcs-cluster.name}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.lwcs-cluster.name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.lwcs-cluster.name}"
KUBECONFIG
}
