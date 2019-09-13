data "aws_ecr_repository" "myapp" {
  name = "${var.ecr-repository}"
}

resource "aws_ecs_cluster" "my_cluster" {
  name       = "${var.app_prefix}"
}

resource "aws_ecs_service" "myapp" {
  name            = "${var.app_prefix}-${var.env}"
  cluster         = "${aws_ecs_cluster.my_cluster.id}"
  task_definition = "${aws_ecs_task_definition.myapp.arn}"
  desired_count   = 3
#  iam_role        = "${aws_iam_role.myapp.arn}"
  network_configuration {
    subnets = ["${aws_subnet.myapp1.id}", "${aws_subnet.myapp2.id}"]
    security_groups = ["${aws_security_group.myapp.id}"]
  }
#  placement_constraints {
#    type  = "distinctInstance"
#  }
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = "${aws_alb_target_group.myapp-tg.arn}"
    container_name   = "go-outyet"
    container_port   = "${var.container1_port}"
  }
  service_registries {
    registry_arn = "${aws_service_discovery_service.myapp.arn}"
#    port         = "${var.container1_port}"  ## Needed for SRV records
  }
  depends_on      = ["aws_iam_role_policy.myapp", "aws_autoscaling_group.app_asg", "aws_cloudwatch_log_group.myapp"]
}

data "template_file" "container_definition" {
  template = "${file("container-definition.json")}"
  vars = {
    #image_url           = "${data.aws_ecr_repository.myapp.repository_url}:${var.image_tag}"
    image_url           = "${data.aws_ecr_repository.myapp.repository_url}"
    container_name      = "go-outyet"
    log_group_region    = "${var.aws_region}"
    log_group_name      = "${var.app_prefix}"
    log_stream_prefix   = "${var.app_prefix}"
    hostport1           = "${var.container1_port}"
    containerport1      = "${var.container1_port}"
  }
}

resource "aws_ecs_task_definition" "myapp" {
  family                = "myapp"
  container_definitions = "${data.template_file.container_definition.rendered}"
  network_mode          = "awsvpc"
}

resource "aws_cloudwatch_log_group" "myapp" {
  name         = "${var.app_prefix}"
}

