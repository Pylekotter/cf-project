# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.cf_vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "wp_subnet" {
  value = aws_subnet.wp_subnet.*.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.cf_rds_subnetgroup.*.name
}

output "bastion_sg" {
  value = aws_security_group.cf-sg["bastion"].id
}

output "wpserver_sg" {
  value = aws_security_group.cf-sg["wpserver"].id
}

output "loadbalancer_sg" {
  value = aws_security_group.cf-sg["loadbalancer"].id
}

output "rds_sg" {
  value = aws_security_group.cf-sg["rds"].id
}
