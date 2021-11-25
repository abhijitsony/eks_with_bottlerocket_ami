########## VPC variables ##########
variable "name" {}
variable "region" {}
variable "cidr_block" {}
variable "az_counts" {}
variable "cs_user_aws_arn" {}
variable "cs_user_aws_username" {}
########## Launch template variables ##########
variable "bottlerocket" {}
variable "labels" {}
variable "taints" {}
variable "bottlerocket_admin_source" {}
variable "instance_size" {}
variable "key_name" {}
variable "root_volume_size" {}
########## IAM Variables ##########
variable "tags" {}
variable "cluster_autoscaler" {}
########## Worker node variables ##########
variable "worker_desired_size" {}
variable "worker_max_size" {}
variable "worker_min_size" {}
########## EKS Variables ##########
variable "legacy_security_groups" {}
variable "log_retention" {}
variable "aws_auth_role_map" {}
variable "aws_auth_user_map" {}
variable "fstype" {}
variable "eks_version" {}
