# --- networking/variables.tf ---

variable "vpc_cidr" {}
variable "public_cidrs" {}
variable "wp_sn_cidrs" {}
variable "db_sn_cidrs" {}
variable "public_sn_count" {}
variable "wp_sn_count" {}
variable "db_sn_count" {}
variable "security_groups" {}
variable "db_subnet_group" {
}

