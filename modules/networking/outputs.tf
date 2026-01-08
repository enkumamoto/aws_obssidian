output "public_route_table_ids" {
  value = [aws_route_table.route_table_public.id]
}

output "intra_route_table_ids" {
  value = [aws_route_table.route_table_private.id]
}

output "security_group_ids" {
  value = aws_security_group.obsidianSG.id
}

output "public_subnet_ids" {
  value = [aws_subnet.az_a["public"].id, aws_subnet.az_b["public"].id, aws_subnet.az_c["public"].id]
}

output "private_app_subnet_ids" {
  value = [aws_subnet.az_a["private_app"].id, aws_subnet.az_b["private_app"].id, aws_subnet.az_c["private_app"].id]
}
