/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${var.rdt_vcp.id}"
  count                   = "${length(var.public_subnets_cidr)}"
  cidr_block              = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones,   count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name        = "GitLab Public Subnet-${element(var.availability_zones, count.index)}"
    Project     = "${var.aws_project_name}"
    Terraform   = true
  }
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${var.rdt_vcp.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index )}"
  availability_zone       = "${element(var.availability_zones,   count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "GitLab Private Subnet-${element(var.availability_zones, count.index)}"
    Project     = "${var.aws_project_name}"
    Terraform   = true
  }
}

/* Elastic IP for NAT */
# NOTE: I think I have to remove this instance
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  count      = "${length(var.public_subnets_cidr)}"
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig"{
  vpc_id = var.rdt_vcp.id

  tags = {
    Environment         = "PROD"
    Managed_By          = "rdt-gov"
    Name                = "rdt-igw"
    ResponsibleParty    = "AntennaServices"
  }
}

/* NAT */
# TODO: Remove 0
resource "aws_nat_gateway" "public_nat" {
  count         = "${length(var.public_subnets_cidr)}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "GitLab NAT Gateway Public ${count.index}"
    Project     = "${var.aws_project_name}"
    Terraform   = true
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  count         = "${length(var.private_subnets_cidr)}"
  vpc_id = "${var.rdt_vcp.id}"
  tags = {
    Name        = "GitLab Private Route Table ${count.index}"
    Project     = "${var.aws_project_name}"
    Terraform   = true
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  count         = "${length(var.private_subnets_cidr)}"
  vpc_id        = "${var.rdt_vcp.id}"
  tags = {
    Project     = "${var.aws_project_name}"
    Name        = "GitLab Public Route Table ${count.index}"
    Terraform   = true
  }
}

resource "aws_route" "public_internet_gateway" {
  count         = "${length(var.public_subnets_cidr)}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route" "private_nat_gateway" {
  count                  = "${length(aws_route_table.private)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.public_nat.*.id, count.index)}"
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index) }"
}

/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
  name        = "${var.aws_project_name}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${var.rdt_vcp.id}"
  depends_on  = [var.rdt_vcp]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Project     = "${var.aws_project_name}"
    Name        = "GitLab Default Security Group"
    Terraform   = true
  }
}

