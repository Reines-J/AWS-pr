
resource "aws_efs_file_system" "terra-eks-test-efs" {
  creation_token = "terra-eks-test-efs"
  tags = merge(var.eks_tag,
  {
    "Name" = format("%s-%s", var.resource_tag, "EFS")
  })
}

resource "aws_efs_mount_target" "terra-eks-test-mnt" {
  count = length(var.az)
  file_system_id = aws_efs_file_system.terra-eks-test-efs.id
  subnet_id = element(aws_subnet.prisubnet.*.id, count.index)
  security_groups = [ "${module.eks.worker_security_group_id}" ]
}