# --- route53/main.tf ---

resource "aws_route53_zone" "clientapp_zone" {
  name = var.record_name
}

resource "aws_route53_record" "clientapp_record" {
  name    = var.record_name
  type    = "A"
  zone_id = aws_route53_zone.clientapp_zone.zone_id

  alias {
    name                   = var.alias_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}