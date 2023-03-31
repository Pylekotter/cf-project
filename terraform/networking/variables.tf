# --- networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(any)
}

variable "wp_sn_cidrs" {
  type = list(any)
}

variable "db_sn_cidrs" {
  type = list(any)
}

variable "public_sn_count" {
  type = number
}

variable "wp_sn_count" {
  type = number
}

variable "db_sn_count" {
  type = number
}

variable "security_groups" {}