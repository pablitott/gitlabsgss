resource "aws_vpc" "vpc"{
  cidr_block        = "${var.vpc_cidr}"
  instance_tenancy  = "default"

    tags = {
        Name        = "${var.aws_project_name}-vpc"
        Project     = "${var.aws_project_name}"
        Terraform   = true
    }
}

/*==== Subnets ======*/
/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${var.public_subnets_count}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, var.subnet_bit, count.index)}"
  availability_zone       = "${element(var.availability_zones.*.id,   count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name        = "public-subnet-${element(var.availability_zones.*.id, count.index)}"
    Project     = "${var.aws_project_name}"
    Terraform   = true
  }
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${var.private_subnets_count}"
  # cidr_block              = "${element(var.private_subnets_cidr, count.index)}"

  cidr_block              = "${cidrsubnet(var.vpc_cidr, var.subnet_bit, count.index + var.public_subnets_count)}"
  availability_zone       = "${element(var.availability_zones.*.id,   count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "private-subnet-${element(var.availability_zones.*.id, count.index)}"
    Project     = "${var.aws_project_name}"
    Terraform   = true
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig"{
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "default"
    Project     = var.aws_project_name
    Terraform   = true
  }
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, 0)}"
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "nat gateway"
    Project     = "${var.aws_project_name}"
    Terraform   = true
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "private-route-table"
    Project     = "${var.aws_project_name}"
    Terraform   = true
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Project     = "${var.aws_project_name}"
    Name        = "public-route-table"
    Terraform   = true
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = "${var.public_subnets_count}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${var.private_subnets_count}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
  name        = "${var.aws_project_name}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"
  depends_on  = [aws_vpc.vpc]
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
    Name        = "default security group"
    Terraform   = true
  }
}
