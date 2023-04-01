
# --- database/main.tf ---

resource "aws_db_instance" "cf_db" {
  allocated_storage      = 30
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = var.dbname
  username               = var.dbuser
  password               = var.dbpassword
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.rds_sg
  identifier             = var.db_identifier
  skip_final_snapshot    = var.skip_db_snapshot
  tags = {
    Name = "RDS1"
  }
}