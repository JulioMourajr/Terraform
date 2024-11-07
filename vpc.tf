resource "aws_vpc" "ada_vpc" {
  cidr_block = var.cidrvpc

  tags = {
    vpc  = "ada"
    Name = "terraformada"
  }
}

resource "aws_subnet" "publica-a" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "publica-a"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "publica-b" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "publica-b"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "publica-c" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "publica-c"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_internet_gateway" "gw-ada" {
  vpc_id = aws_vpc.ada_vpc.id

  tags = {
    Name = "gw-ada"
  }
}

resource "aws_subnet" "privadaapp-a" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "privadaapp-a"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "privadaapp-b" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "privadaapp-b"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "privadaapp-c" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "privadaapp-c"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_eip" "nat_eip_a" {

}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.publica-a.id

  tags = {
    Name = "gw-nat-a"
  }

  depends_on = [aws_internet_gateway.gw-ada]

}

resource "aws_eip" "nat_eip_b" {

}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.publica-b.id

  tags = {
    Name = "gw-nat-b"
  }

  depends_on = [aws_internet_gateway.gw-ada]

}

resource "aws_eip" "nat_eip_c" {

}

resource "aws_nat_gateway" "nat_gateway_c" {
  allocation_id = aws_eip.nat_eip_c.id
  subnet_id     = aws_subnet.publica-c.id

  tags = {
    Name = "gw-nat-c"
  }

  depends_on = [aws_internet_gateway.gw-ada]

}

resource "aws_subnet" "bd-a" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "bd-a"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "bd-b" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.9.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "bd-b"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_subnet" "bd-c" {
  vpc_id            = aws_vpc.ada_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "bd-c"
  }

  depends_on = [aws_vpc.ada_vpc]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-ada.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.publica-a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.publica-b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.publica-c.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "banco" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

}

resource "aws_route_table_association" "bd_a" {
  subnet_id      = aws_subnet.bd-a.id
  route_table_id = aws_route_table.banco.id
}

resource "aws_route_table_association" "bd_b" {
  subnet_id      = aws_subnet.bd-b.id
  route_table_id = aws_route_table.banco.id
}

resource "aws_route_table_association" "bd_c" {
  subnet_id      = aws_subnet.bd-c.id
  route_table_id = aws_route_table.banco.id
}

resource "aws_route_table" "privadaappa" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }
}

resource "aws_route_table" "privadaappb" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_b.id
  }
}

resource "aws_route_table" "privadaappc" {
  vpc_id = aws_vpc.ada_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_c.id
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.privadaapp-a.id
  route_table_id = aws_route_table.privadaappa.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.privadaapp-b.id
  route_table_id = aws_route_table.privadaappb.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.privadaapp-c.id
  route_table_id = aws_route_table.privadaappc.id
}

