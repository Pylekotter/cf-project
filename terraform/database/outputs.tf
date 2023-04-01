# --- database/outputs.tf ---

output "db_endpoint" {
  value = aws_db_instance.cf_db.endpoint
}