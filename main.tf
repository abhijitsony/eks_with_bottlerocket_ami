provider "aws" {
  region                 = var.vpc.vpc.region
  profile                = var.vpc.vpc.aws_profile
  skip_region_validation = true
}

## The 'aws_eks_bottlerocket' module listed below will create an AWS EKS
##  cluster using the latest 'bottlerocket' AMI image.
##  All of the variables listed within the module below can be set/change
##   within the root module variables.tf file.
module "aws_eks_bottlerocket" {
  source                    = "./modules/aws_eks_bottlerocket"
  name                      = var.vpc.vpc.name
  region                    = var.vpc.vpc.region
  cidr_block                = var.vpc.vpc.cidr_block
  az_counts                 = var.vpc.vpc.az_counts
  cs_user_aws_arn           = var.vpc.vpc.cs_user_aws_arn
  cs_user_aws_username      = var.vpc.vpc.cs_user_aws_username
  bottlerocket              = var.launch_template.lt.bottlerocket
  labels                    = var.launch_template.lt.labels
  taints                    = var.launch_template.lt.taints
  bottlerocket_admin_source = var.launch_template.lt.bottlerocket_admin_source
  instance_size             = var.launch_template.lt.instance_size
  key_name                  = var.launch_template.lt.key_name
  root_volume_size          = var.launch_template.lt.root_volume_size
  tags                      = var.iam.iam.tags
  cluster_autoscaler        = var.iam.iam.cluster_autoscaler
  worker_desired_size       = var.worker_nodes.worker_nodes.worker_desired_size
  worker_max_size           = var.worker_nodes.worker_nodes.worker_max_size
  worker_min_size           = var.worker_nodes.worker_nodes.worker_min_size
  legacy_security_groups    = var.legacy_security_groups
  log_retention             = var.log_retention
  aws_auth_role_map         = var.aws_auth_role_map
  aws_auth_user_map         = var.aws_auth_user_map
  fstype                    = var.fstype
  eks_version               = var.eks_version
}
