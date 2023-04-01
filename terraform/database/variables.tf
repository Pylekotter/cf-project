# --- database/variables.tf ----

variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}
variable "rds_sg" {}
variable "db_subnet_group_name" {}
variable "db_engine_version" {}
variable "db_identifier" {}
variable "skip_db_snapshot" {}