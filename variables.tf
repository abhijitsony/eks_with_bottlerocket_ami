#####################################################################
## All of the different variables listed below are used with the
##  'aws_eks_bottlerocket' module.
#####################################################################
##  Prior to running this terraform code you should set the following
##  values for the variable 'vpc':
##    region = AWS region deploying to.
##    cidr_block = Set the cidr notation for the netowrk.
##      example: "10.0.0.0/16"
##    az_counts = Number of AWS Availability Zones
############### VPC variables #######################################
variable "vpc" {
  description = "Variables needed to deploy the VPC, Subnets etc."
  type        = map(any)
  default = {
    vpc = {
      name              = ""
      aws_profile       = ""
      region            = ""
      cidr_block        = ""
      az_counts         = 3
      user_aws_arn      = ""
  }
}
#####################################################################
##  Prior to running this terraform code you should set the following
##  values for the variable 'launch_template':
##    labels = To set the labels on the worker nodes in the cluster
##    instance_size = Set an AWS Instance Type.
##  Optional values that can be changed:
##    key_name = An AWS ssh key name for use to log into the nodes
##    root_volume_size = Size of the root disk on the worker nodes
############################ Launch template variables
variable "launch_template" {
  description = "Variables needed for bottlerocket_config.toml.tpl"
  type        = map(any)
  default = {
    lt = {
      bottlerocket              = true
      labels                    = { }
      taints                    = {}
      bottlerocket_admin_source = ""
      instance_size             = ""
      key_name                  = ""
      root_volume_size          = 40
    }
  }
}
############################ IAM Variables
variable "iam" {
  description = "Variables needed for IAM resources"
  type        = map(any)
  default = {
    iam = {
      tags               = {}
      cluster_autoscaler = true
    }
  }
}
########################### Worker node variables
variable "worker_nodes" {
  description = "Variables needed for worker node deployment"
  type        = map(any)
  default = {
    worker_nodes = {
      worker_desired_size = 3
      worker_max_size     = 5
      worker_min_size     = 3
    }
  }
}
########################## EKS Variables
variable "legacy_security_groups" {
  type        = bool
  default     = false
  description = "Preserves existing security group setup from pre 1.15 clusters, to allow existing clusters to be upgraded without recreation"
}
variable "log_retention" {
  type    = string
  default = "30"
}
variable "aws_auth_role_map" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default     = []
  description = "A list of mappings from aws role arns to kubernetes users, and their groups"
}
variable "aws_auth_user_map" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default     = []
  description = "A list of mappings from aws user arns to kubernetes users, and their groups"
}
variable "fstype" {
  type        = string
  default     = "xfs"
  description = "File system type that will be formatted during volume creation, (xfs, ext2, ext3 or ext4)"
}
variable "eks_version" {
  type    = string
  default = "1.20"
}