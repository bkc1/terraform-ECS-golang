resource "aws_service_discovery_private_dns_namespace" "myapp" {
  name        = "terraform.local"
  description = "Example private namespace for service discovery"
  vpc         = "${aws_vpc.myapp.id}"
}

resource "aws_service_discovery_service" "myapp" {
  name = "myapp"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.myapp.id}"
    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }
#  dns_config {
#    namespace_id = "${aws_service_discovery_private_dns_namespace.myapp.id}"
#    dns_records {
#      ttl  = 10
#      type = "SRV"
#    }
#    routing_policy = "MULTIVALUE"
#  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
