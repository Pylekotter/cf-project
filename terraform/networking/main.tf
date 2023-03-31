# --- networking/main.tf ---

# --- VPC ---

resource "aws_vpc" "cf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "cf_vpc"
  }
}

# --- Internet Gateway ---

resource "aws_internet_gateway" "cf-igw" {
  vpc_id = aws_vpc.cf_vpc.id

  tags = {
    Name = "cf-igw"
  }
}

# --- Nat Gateway ---

resource "aws_eip" "nat-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.cf-igw]

  tags = {
    Name = "cf-nat-eip"
  }
}

resource "aws_nat_gateway" "cf-nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "cf-nat"
  }

  depends_on = [aws_internet_gateway.cf-igw]
}

# --- Subnets ---

resource "aws_subnet" "public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.cf_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = ["us-west-2a", "us-west-2b"][count.index]

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "wp_subnet" {
  count             = var.wp_sn_count
  vpc_id            = aws_vpc.cf_vpc.id
  cidr_block        = var.wp_sn_cidrs[count.index]
  availability_zone = ["us-west-2a", "us-west-2b"][count.index]

  tags = {
    Name = "wp_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "db_subnet" {
  count             = var.db_sn_count
  vpc_id            = aws_vpc.cf_vpc.id
  cidr_block        = var.db_sn_cidrs[count.index]
  availability_zone = ["us-west-2a", "us-west-2b"][count.index]

  tags = {
    Name = "db_subnet_${count.index + 1}"
  }
}

# --- Route Tables ---

resource "aws_route_table" "cf_public_rt" {
  vpc_id = aws_vpc.cf_vpc.id

  tags = {
    Name = "cf_public_rt"
  }
}

resource "aws_route_table" "cf_private_rt" {
  vpc_id = aws_vpc.cf_vpc.id

  tags = {
    Name = "cf_private_rt"
  }
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.cf_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cf-igw.id
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.cf_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.cf-nat.id
}


resource "aws_route_table_association" "cf_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.cf_public_rt.id
}

resource "aws_route_table_association" "cf_wp_assoc" {
  count          = var.wp_sn_count
  subnet_id      = aws_subnet.wp_subnet.*.id[count.index]
  route_table_id = aws_route_table.cf_private_rt.id
}

resource "aws_route_table_association" "db_wp_assoc" {
  count          = var.db_sn_count
  subnet_id      = aws_subnet.db_subnet.*.id[count.index]
  route_table_id = aws_route_table.cf_private_rt.id
}

# --- Security Groups ---

resource "aws_security_group" "cf-sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.cf_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
