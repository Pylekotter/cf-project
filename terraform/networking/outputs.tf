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

output "bastion_sg" {
  value = aws_security_group.cf-sg["bastion"].id
}

output "wpserver_sg" {
  value = aws_security_group.cf-sg["wpserver"].id
}
