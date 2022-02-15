variable "region" {
  description = "region"
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "vpc cidr"
}

variable "public_subnets" {
  description = "public subnet cidr"
    default = {
      "0" = "1"
      "1" = "2"
  }
}

variable "private_subnets" {
  description = "private subnet cidr"
    default = {
      "0" = "3"
      "1" = "4"
  }
}

variable "az" {
  description = "Availability Zones"
  type = list(string)
}

variable "resource_tag" {
  description = "resource tag"
  type = string
}

variable "eks_tag" {
  description = "EKS tag"
  type = map(string)
  default = {
    "kubernetes.io/cluster/terra-eks-test" = "shared"
  }
}