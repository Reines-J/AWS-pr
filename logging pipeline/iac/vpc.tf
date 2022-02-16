resource "aws_vpc" "vpc" {
  cidr_block           = "10.${var.vpc_cidr}.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "VPC")
  })
}

resource "aws_subnet" "pubsubnet" {
  count             = length(var.az)
  cidr_block        = "10.${var.vpc_cidr}.${var.public_subnets[count.index]}.0/24"
  vpc_id            = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  availability_zone = var.az[count.index]
  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "PUBLIC${count.index + 1}")
    "kubernetes.io/role/elb"= 1
  })
}

resource "aws_subnet" "prisubnet" {
  count             = length(var.az)
  cidr_block        = "10.${var.vpc_cidr}.${var.private_subnets[count.index]}.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az[count.index]
  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "PRIVATE${count.index + 1}")
    "kubernetes.io/role/internal-elb"= 1
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "IGW")
  })
}

resource "aws_eip" "nat" {
  count = length(var.az)
  vpc   = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.az)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.pubsubnet.*.id, count.index)
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "NGW")
  })
}

resource "aws_route_table" "pubroute" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "PUBLIC-ROUTE")
  })
}

resource "aws_route_table" "priroute" {
  count = length(aws_subnet.prisubnet.*.id)
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "PRIVATE-ROUTE${count.index + 1}")
  })
}

resource "aws_route" "pubrt" {
  route_table_id = aws_route_table.pubroute.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "prirt" {
  count = length(aws_subnet.prisubnet.*.id)
  route_table_id = element(aws_route_table.priroute.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
}

resource "aws_route_table_association" "pubrouteassoc" {
  count = length(aws_subnet.pubsubnet.*.id)
  route_table_id = aws_route_table.pubroute.id
  subnet_id      = element(aws_subnet.pubsubnet.*.id, count.index)
}

resource "aws_route_table_association" "prirouteassoc" {
  count = length(aws_subnet.prisubnet.*.id)
  route_table_id = element(aws_route_table.priroute.*.id, count.index)
  subnet_id      = element(aws_subnet.prisubnet.*.id, count.index)
}