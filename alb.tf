resource "aws_alb" "myapp" {
  name            = "${var.app_prefix}"
  subnets         = ["${aws_subnet.myapp1.id}", "${aws_subnet.myapp2.id}"]
  security_groups = ["${aws_security_group.myapp-elb.id}"]
  tags = {
    Environment   = "${var.app_prefix}"
  }
}

resource "aws_alb_target_group" "myapp-tg" {
  name_prefix       = "${var.app_prefix}"
  port              = 8080
  protocol          = "HTTP"
  target_type       = "ip"
  vpc_id            = "${aws_vpc.myapp.id}"
  health_check {
    protocol            = "HTTP"
    interval            = 10
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 3
    matcher             = 200
  }  
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Environment = "${var.app_prefix}"
  }
  depends_on = ["aws_alb.myapp"]
}

resource "aws_alb_listener" "myapp" {
  load_balancer_arn = "${aws_alb.myapp.arn}"
  port              = "80"
  protocol          = "HTTP"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = "${lookup(var.ssl_cert_arn, var.aws_region)}"
  default_action {
    target_group_arn = "${aws_alb_target_group.myapp-tg.arn}"
    type             = "forward"
  }
}
