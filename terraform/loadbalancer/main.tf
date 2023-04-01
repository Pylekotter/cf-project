# --- loadbalancer/main.tf ---

resource "aws_lb" "wp_lb" {
  name            = "wp-loadbalancer"
  subnets         = var.public_subnet
  security_groups = [var.loadbalancer_sg]
  idle_timeout    = 400
}

resource "aws_lb_target_group" "wp_tg" {
  name     = "wp-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
  health_check {
    healthy_threshold   = var.elb_healthy_threshold
    unhealthy_threshold = var.elb_unhealthy_threshold
    timeout             = var.elb_timeout
    interval            = var.elb_interval
  }
}

resource "aws_lb_listener" "wp_lb_listener" {
  load_balancer_arn = aws_lb.wp_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_tg.arn
  }
}