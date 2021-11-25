resource "aws_vpc" "lwcs" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# Internet gateway
resource "aws_internet_gateway" "lwcs_network_gateway" {
  vpc_id = aws_vpc.lwcs.id

  tags = {
    Name = "${var.name}-network_gateway"
  }
}

# NAT gateway
resource "aws_eip" "lwcs_network_nat_gateway-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.lwcs_network_gateway]

  tags = {
    Name = "${var.name}-nat-gateway"
  }
}

resource "aws_route_table" "lwcs_network_public" {
  vpc_id = aws_vpc.lwcs.id

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route" "lwcs-internet-gateway" {
  route_table_id         = aws_route_table.lwcs_network_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lwcs_network_gateway.id
}

resource "aws_route_table" "lwcs_network_private" {
  vpc_id = aws_vpc.lwcs.id

  tags = {
    Name = "${var.name}-private"
  }
}

resource "tls_private_key" "lwcs_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#resource "local_file" "lwcs_private_key" {
#  content              = 
#  filename             = "kubeconfig_${aws_eks_cluster.lwcs-cluster.name}"
#  file_permission      = "0600"
#  directory_permission = "0755"
#}

resource "aws_key_pair" "lwcs_generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.lwcs_private_key.public_key_openssh
}
