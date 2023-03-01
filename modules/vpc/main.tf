#create VPC
resource "aws_vpc" "create_vpc" {
  cidr_block       = var.vpc.cidr_block
  instance_tenancy = "default"

  tags = merge(var.req_tags,
    {
      Name = var.vpc.vpc_name
    }
  )
}

#create internet gateway
resource "aws_internet_gateway" "create_igw" {
  vpc_id = aws_vpc.create_vpc.id

  tags = merge(var.req_tags, {
    Name = var.vpc.igw_name
    }
  )
}

#create vpc public subnets
resource "aws_subnet" "create_public_sub" {
  count             = "${length(var.vpc.public_cidr)}"
  vpc_id            = aws_vpc.create_vpc.id
  availability_zone = var.vpc.public_av_zone[count.index]
  cidr_block        = var.vpc.public_cidr[count.index]

  tags = merge(var.req_tags, {
    Name = var.vpc.subnet_public_name[count.index]
    }
  )
}

#create vpc private subnets
resource "aws_subnet" "create_private_sub" {
  count             = "${length(var.vpc.private_cidr)}"
  vpc_id            = aws_vpc.create_vpc.id
  availability_zone = var.vpc.private_av_zone[count.index]
  cidr_block        = var.vpc.private_cidr[count.index]

  tags = merge(var.req_tags, {
    Name = var.vpc.subnet_private_name[count.index]
    }
  )
}

#create vpc db subnets
resource "aws_subnet" "create_db_sub" {
  count             = "${length(var.vpc.db_cidr)}"
  vpc_id            = aws_vpc.create_vpc.id
  availability_zone = var.vpc.db_av_zone[count.index]
  cidr_block        = var.vpc.db_cidr[count.index]

  tags = merge(var.req_tags, {
    Name = var.vpc.subnet_db_name[count.index]
    }
  )
}

#create nat gateway
resource "aws_nat_gateway" "create_nat" {
  allocation_id     = var.vpc.elastic_ip_allocation_id
  subnet_id         = aws_subnet.create_public_sub[0].id
  connectivity_type = "public"

  tags = merge(var.req_tags, {
    Name = var.vpc.nat_name
    }
  )
}

 #create route tables
resource "aws_route_table" "create_public_rt" {
  vpc_id = aws_vpc.create_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.create_igw.id
  }

  tags = merge(var.req_tags, {
    Name = var.vpc.public_rt_name
    }
  )
}

resource "aws_route_table" "create_private_rt" {
  vpc_id = aws_vpc.create_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.create_nat.id
  }

  tags = merge(var.req_tags, {
    Name = var.vpc.private_rt_name
    }
  )
}

#associate public route table to subnet
resource "aws_route_table_association" "public_rt_assoc" {
  count             = "${length(var.vpc.public_cidr)}"
  subnet_id      = aws_subnet.create_public_sub[count.index].id
  route_table_id = aws_route_table.create_public_rt.id
}

#associate private route table to subnet
resource "aws_route_table_association" "private_rt_assoc" {
  count             = "${length(var.vpc.private_cidr)}"
  subnet_id      = aws_subnet.create_private_sub[count.index].id
  route_table_id = aws_route_table.create_private_rt.id
}

#create VPC endpoint
resource "aws_vpc_endpoint" "create_s3endpoint" {
  vpc_id            = aws_vpc.create_vpc.id
  service_name      = "com.amazonaws.ap-southeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.create_public_rt.id, aws_route_table.create_private_rt.id]

 tags = merge(var.req_tags, {
    Name = var.vpc.s3_endpoint_name
    }
  )
}
