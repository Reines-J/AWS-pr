data "aws_subnet_ids" "pub"{
  vpc_id = aws_vpc.vpc.id
  filter {
    name = "subnet-id"
    values = aws_subnet.pubsubnet.*.id
  }
}

data "aws_subnet_ids" "pri"{
    vpc_id  = aws_vpc.vpc.id
    filter {
      name = "subnet-id"
      values = aws_subnet.prisubnet.*.id
    }
}

data "aws_subnet_ids" "all"{
    vpc_id  = aws_vpc.vpc.id
    filter {
      name = "vpc-id"
      values = aws_vpc.vpc.*.id
    }
}
