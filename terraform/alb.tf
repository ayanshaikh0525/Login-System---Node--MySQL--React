resource "aws_lb" "app_lb" {
  name = "app-lb"

  internal = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_1.id, 
    aws_subnet.public_2.id
  ]

  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "ecs_tg" {
  name = "ecs-target-group"
  port = 5000
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/auth/health"
    protocol = "HTTP"
    matcher  = "200"
    interval = 30
    timeout  = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}
