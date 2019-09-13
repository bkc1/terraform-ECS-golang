# EC2 instances for  ECS cluster
resource "aws_launch_configuration" "app_lc" {
  name_prefix          = "${var.app_prefix}"
  image_id             = "${data.aws_ami.ecs.id}"
  instance_type        = "t2.large"
  enable_monitoring    = true
  key_name             = "${aws_key_pair.myapp.key_name}"
  security_groups      = ["${aws_security_group.myapp.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.myapp.name}"
  user_data            = "${file("${var.cloud_init}")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name_prefix          = "${var.app_prefix}"
  launch_configuration = "${aws_launch_configuration.app_lc.name}"
  min_size             = 3
  max_size             = 5
  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
  vpc_zone_identifier       = ["${aws_subnet.myapp1.id}", "${aws_subnet.myapp2.id}"]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "${var.app_prefix}"
    propagate_at_launch = true
  }
}

