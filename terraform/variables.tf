variable "aws_region" {
  default = "us-west-2"
}

variable "access_ip" {}

#-------database variables

variable "dbname" {
  type    = string
  default = "rds1"
}
variable "dbuser" {
  type    = string
  default = "postgres"
}
variable "dbpassword" {
  type      = string
  sensitive = true
}