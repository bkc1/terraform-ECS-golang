variable "public_key_path" {
  description = "Enter path to the public key"
  default     = "keys/mykey.pub"
}

variable "key_name" {
  description = "Enter name of private key"
  default     = "mykey"
}

variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "us-west-2"
}

variable "app_prefix" {
  description = "Application abbreviation/prefix"
  default     = "myapp"
}

variable "az" {
  description = "Availability Zones per region"
  default = {
    us-east-1 = "us-east-1a,us-east-1c,us-east-1d,us-east-1e"
    us-west-1 = "us-west-1b,us-west-1c"
    us-west-2 = "us-west-2a,us-west-2b,us-west-2c"
  }
}

variable "instance_count" {
  default = {
    "0" = "1"
    "1" = "2"
    "2" = "3"
  }
}

#user-data cloud-init script
variable "cloud_init" {
  default = "ecs_bootstrap.sh"
}

variable "env" {
  default = "dev"
}

## Public R53 zone needs to be pre-created and exist
variable "domain_name" {
  default = "example.io"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/21"
}

variable "subnet1" {
  default = "10.0.1.0/24"
}

variable "subnet2" {
  default = "10.0.2.0/24"
}

variable "image_name" {
  default = "go-outyet"
}

variable "image_tag" {
  default = "latest"
}

variable "container1_port" {
  default = "8080"
}

variable "ecr-repository" {
  default = "go-outyet"
}


