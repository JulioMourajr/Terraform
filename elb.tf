resource "aws_lb_target_group" "meu-tg" {
  name     = "meu-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ada_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "meu-tg"
  }
}

resource "aws_lb_target_group_attachment" "meu_tg_attachment-1" {
  target_group_arn = aws_lb_target_group.meu-tg.arn
  target_id        = aws_instance.ada-ec2-julio1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "meu_tg_attachment-2" {
  target_group_arn = aws_lb_target_group.meu-tg.arn
  target_id        = aws_instance.ada-ec2-julio2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "meu_tg_attachment-3" {
  target_group_arn = aws_lb_target_group.meu-tg.arn
  target_id        = aws_instance.ada-ec2-julio3.id
  port             = 80
}

resource "aws_lb_listener" "meu_listener" {
  load_balancer_arn = aws_lb.ada-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.meu-tg.arn
  }
}

resource "aws_security_group" "for_elb" {
  name        = "for_elb"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.ada_vpc.id

  tags = {
    Name = "for_elb"
  }
}

resource "aws_security_group_rule" "for_elb_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.for_elb.id
  cidr_blocks       = [aws_vpc.ada_vpc.cidr_block]
}

resource "aws_security_group_rule" "for_elb_rule_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.for_elb.id
  cidr_blocks       = [aws_vpc.ada_vpc.cidr_block]
}

resource "aws_lb" "ada-lb" {
  name                             = "ada-lb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.for_elb.id]
  subnets                          = [aws_subnet.publica-a.id, aws_subnet.publica-b.id, aws_subnet.publica-c.id]
  enable_deletion_protection       = false
  enable_http2                     = true
  idle_timeout                     = 60
  enable_cross_zone_load_balancing = true
  tags = {
    Name = "ada-lb"
  }
}
