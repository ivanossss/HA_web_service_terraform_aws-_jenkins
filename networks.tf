#---------------------Network------------------------------------------------------------

resource "aws_vpc" "i_m_web" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.i_m_web.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.i_m_web.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-north-1b"
}

resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.i_m_web.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-north-1c"
}

resource "aws_internet_gateway" "i_m_igw" {
  vpc_id = aws_vpc.i_m_web.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.i_m_web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i_m_igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_association_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_association_c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.public_rt.id
}