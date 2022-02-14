resource "aws_security_group" "eks-sg" {
  vpc_id = aws_vpc.vpc.id
  name = "eks-sg"
  description = "eks-sg"
  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "SG")
  })
}

resource "aws_security_group_rule" "https" {
  type = "ingress"
  from_port =  443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.eks-sg.id
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port =  22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.eks-sg.id
}

resource "aws_security_group_rule" "outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0"]
  security_group_id = aws_security_group.eks-sg.id
}
