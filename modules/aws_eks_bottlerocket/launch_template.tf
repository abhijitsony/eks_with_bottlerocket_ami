locals {
  instance_profile_arn = aws_iam_role.lwcs-managed_workers
  root_device_mappings = tolist(data.aws_ami.lwcs-bottlerocket_image.block_device_mappings)[0]
  autoscaler_tags      = var.cluster_autoscaler ? { "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${var.name}" = "owned" } : {}
  bottlerocket_tags    = { "Name" = "eks-node-aws_eks_cluster.cluster.name" }
  tags                 = merge(var.tags, { "kubernetes.io/cluster/${var.name}" = "owned" }, local.autoscaler_tags, local.bottlerocket_tags)
  labels = merge(
    var.labels
  )
}

resource "aws_launch_template" "lwcs-bottlerocket_lt" {
  name_prefix            = "${var.name}"
  update_default_version = true
  block_device_mappings {
    device_name = local.root_device_mappings.device_name

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = local.root_device_mappings.ebs.volume_type
      delete_on_termination = true
    }
  }

  instance_type = var.instance_size

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
  }

  image_id  = data.aws_ami.lwcs-bottlerocket_image.id
  user_data = base64encode(data.template_file.lwcs-bottlerocket_config.rendered)

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }
  tags = local.tags

  key_name = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}
