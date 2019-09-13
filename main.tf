# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_key_pair" "myapp" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

terraform {
  required_version = ">= 0.11.1"
}


# AMZN 2 ECS optimized
data "aws_ami" "ecs" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners      = ["amazon"]
}

data "aws_billing_service_account" "main" {}
