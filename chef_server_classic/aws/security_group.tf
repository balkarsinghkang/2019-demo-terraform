resource "aws_security_group" "chef_server" {
  name        = "chef_server_${random_id.instance_id.hex}"
  description = "Chef Server"
  vpc_id      = "${aws_vpc.chef-server-vpc.id}"

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
  security_group_id = "${aws_security_group.chef_server.id}"
}

/////////////////////////
// Habitat Supervisor Rules
# Allow Habitat Supervisor http communication tcp
resource "aws_security_group_rule" "ingress_allow_9631_tcp" {
  type                     = "ingress"
  from_port                = 9631
  to_port                  = 9631
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.chef_server.id}"
  source_security_group_id = "${aws_security_group.chef_server.id}"
}

# Allow Habitat Supervisor http communication udp
resource "aws_security_group_rule" "ingress_allow_9631_udp" {
  type                     = "ingress"
  from_port                = 9631
  to_port                  = 9631
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.chef_server.id}"
  source_security_group_id = "${aws_security_group.chef_server.id}"
}

# Allow Habitat Supervisor ZeroMQ communication tcp
resource "aws_security_group_rule" "ingress_9638_tcp" {
  type                     = "ingress"
  from_port                = 9638
  to_port                  = 9638
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.chef_server.id}"
  source_security_group_id = "${aws_security_group.chef_server.id}"
}

# Allow Habitat Supervisor ZeroMQ communication udp
resource "aws_security_group_rule" "ingress_allow_9638_udp" {
  type                     = "ingress"
  from_port                = 9638
  to_port                  = 9638
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.chef_server.id}"
  source_security_group_id = "${aws_security_group.chef_server.id}"
}

////////////////////////////////
// Chef Server Rules
# HTTP (nginx)
resource "aws_security_group_rule" "ingress_chef_server_allow_80_tcp" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef_server.id}"
}

# HTTPS (nginx)
resource "aws_security_group_rule" "ingress_chef_server_allow_443_tcp" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef_server.id}"
}

# Allow etcd communication
resource "aws_security_group_rule" "ingress_chef_server_allow_2379_tcp" {
  type                     = "ingress"
  from_port                = 2379
  to_port                  = 2380
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.chef_server.id}"
  source_security_group_id = "${aws_security_group.chef_server.id}"
}

# Allow elasticsearch clients
resource "aws_security_group_rule" "ingress_chef_server_allow_9200_to_9400_tcp" {
  type                     = "ingress"
  from_port                = 9200
  to_port                  = 9400
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.chef_server.id}"
  source_security_group_id = "${aws_security_group.chef_server.id}"
}

# Allow postgres connections
resource "aws_security_group_rule" "ingress_chef_server_allow_5432_tcp" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.chef_server.id}"
  source_security_group_id = "${aws_security_group.chef_server.id}"
}

# Allow leaderel connections
resource "aws_security_group_rule" "ingress_chef_server_allow_7331_tcp" {
  type                     = "ingress"
  from_port                = 7331
  to_port                  = 7331
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.chef_server.id}"
  source_security_group_id = "${aws_security_group.chef_server.id}"
}

# Allow 4222 for eas
resource "aws_security_group_rule" "ingress_chef_server_allow_4222_tcp" {
  type                     = "ingress"
  from_port                = 4222
  to_port                  = 4222
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.chef_server.id}"
}

# Egress: ALL
resource "aws_security_group_rule" "linux_egress_allow_0-65535_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef_server.id}"
}
