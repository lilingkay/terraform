create load balancer
resource "aws_lb" "create_alb" {
  name               = var.alb.alb_name
  internal           = false
  load_balancer_type = var.alb.alb_type
  security_groups    = [aws_security_group.create_albsg.id]
  subnets            = var.all_public_subnet

  tags = merge(var.req_tags, {
    Name = var.alb.alb_name
    }
  )
}

 #create target group
resource "aws_lb_target_group" "create_tg" {
  name        = var.alb.tg_name
  target_type = var.alb.target_type
  port        = var.alb.tg_port
  protocol    = var.alb.tg_protocol
  vpc_id      = var.vpc_id_pass

  health_check {
    path                = var.alb.hc_path
    port                = var.alb.hc_port
    protocol            = var.alb.hc_protocol
    timeout             = var.alb.hc_timeout
    healthy_threshold   = var.alb.hc_healthy_threshold
    unhealthy_threshold = var.alb.hc_unhealthy_threshold
    interval            = var.alb.hc_interval
    matcher             = var.alb.hc_matcher
  }

  tags = merge(var.req_tags, {
    Name = var.alb.tg_name
    }
  )
}

#attach listener to target group
resource "aws_lb_listener" "create_listener" {
  load_balancer_arn = aws_lb.create_alb.arn
  port              = var.alb.listener_port
  protocol          = var.alb.listener_protocol

  default_action {
    type             = var.alb.listener_type
    target_group_arn = aws_lb_target_group.create_tg.arn
  }
}
