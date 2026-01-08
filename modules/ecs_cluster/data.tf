data "aws_subnet" "public_subnets" {
  count = length(var.vpc_config_public_subnet_ids)
  id    = var.vpc_config_public_subnet_ids[count.index]
}

data "aws_subnet" "private_subnets" {
  count = length(var.vpc_config_private_subnet_ids)
  id    = var.vpc_config_private_subnet_ids[count.index]
}
