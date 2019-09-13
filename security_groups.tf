## Security group for instances.
resource "aws_security_group" "myapp" {
  name        = "${var.app_prefix}"
  description = "${var.app_prefix} - Terraform managed"
  vpc_id      = "${aws_vpc.myapp.id}"
  tags = {
    Name = "${var.app_prefix}"
  }

 # SSH access
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = "${var.container1_port}"
    to_port         = "${var.container1_port}"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

 # ICMP replys from the VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

# outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "myapp-elb" {
  name        = "${var.app_prefix}-elb"
  description = "${var.app_prefix} ELB sec group - Terraform managed"
  vpc_id      = "${aws_vpc.myapp.id}"
  tags = {
    Name = "${var.app_prefix}-elb"
  }

# outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
