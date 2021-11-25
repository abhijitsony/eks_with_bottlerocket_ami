#Resource to create eks cluster role
resource "aws_iam_role" "lwcs-cluster_role" {
  name = "EKS-${var.name}-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lwcs-cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.lwcs-cluster_role.name
}

resource "aws_iam_role_policy_attachment" "lwcs-cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.lwcs-cluster_role.name
}


# Resource to create eks worker node role

resource "aws_iam_role" "lwcs-managed_workers" {
  name               = "EKS-${var.name}-worker-node-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "lwcs-eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.lwcs-managed_workers.name
}
resource "aws_iam_role_policy_attachment" "lwcs-eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.lwcs-managed_workers.name
}
resource "aws_iam_role_policy_attachment" "lwcs-eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.lwcs-managed_workers.name
}
resource "aws_iam_role_policy_attachment" "lwcs-ssm_managed_instance_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.lwcs-managed_workers.name
}

resource "aws_iam_role_policy" "lwcs-set_name_tag" {
  name = "${var.name}-set_name_tag"
  role = aws_iam_role.lwcs-managed_workers.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:CreateTags"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "lwcs-eks_node" {
  name = "EKS-${var.name}-worker-node-role"
  role = aws_iam_role.lwcs-managed_workers.name
}
