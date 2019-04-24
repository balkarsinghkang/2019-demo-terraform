resource "aws_security_group" "demo_instances" {
  name        = "demo_instances_${random_id.instance_id.hex}"
  description = "Demo Instances"
  vpc_id      = "${aws_vpc.demo_instances-vpc.id}"

  tags {
    Name          = "${var.tag_customer}-${var.tag_project}_${random_id.instance_id.hex}_${var.tag_application}_security_group"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

//////////////////////////
// Base Linux Rules
resource "aws_security_group_rule" "ingress_allow_22_tcp_all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo_instances.id}"
}

/////////////////////////
// Habitat Supervisor Rules
# Allow Habitat Supervisor http communication tcp
resource "aws_security_group_rule" "ingress_allow_9631_tcp" {
  type                     = "ingress"
  from_port                = 9631
  to_port                  = 9631
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.demo_instances.id}"
  source_security_group_id = "${aws_security_group.demo_instances.id}"
}

# Allow Habitat Supervisor http communication udp
resource "aws_security_group_rule" "ingress_allow_9631_udp" {
  type                     = "ingress"
  from_port                = 9631
  to_port                  = 9631
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.demo_instances.id}"
  source_security_group_id = "${aws_security_group.demo_instances.id}"
}

# Allow Habitat Supervisor ZeroMQ communication tcp
resource "aws_security_group_rule" "ingress_9638_tcp" {
  type                     = "ingress"
  from_port                = 9638
  to_port                  = 9638
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.demo_instances.id}"
  source_security_group_id = "${aws_security_group.demo_instances.id}"
}

# Allow Habitat Supervisor ZeroMQ communication udp
resource "aws_security_group_rule" "ingress_allow_9638_udp" {
  type                     = "ingress"
  from_port                = 9638
  to_port                  = 9638
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.demo_instances.id}"
  source_security_group_id = "${aws_security_group.demo_instances.id}"
}

# Allow Hab Ring Viz
resource "aws_security_group_rule" "permanent_peer_allow_3000_tcp" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.demo_instances.id}"
}
# Allow nparks
resource "aws_security_group_rule" "permanent_peer_allow_8080_tcp" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.demo_instances.id}"
}

# Allow nparks mongo
resource "aws_security_group_rule" "permanent_peer_allow_27017_tcp" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.demo_instances.id}"
  security_group_id        = "${aws_security_group.demo_instances.id}"
}

# Egress: ALL
resource "aws_security_group_rule" "linux_egress_allow_0-65535_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.demo_instances.id}"
}
