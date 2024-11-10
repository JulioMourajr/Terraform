## criar security group para as ec2 com http

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.ada_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.ada_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "restrict_all" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
}

resource "aws_instance" "ada-ec2-julio1" {
  ami                    = "ami-063d43db0594b521b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = aws_subnet.privadaapp-a.id
  tags = {
    Name = "ada-ec2-julio1"
  }
}

resource "aws_instance" "ada-ec2-julio2" {
  ami                    = "ami-063d43db0594b521b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = aws_subnet.privadaapp-b.id
  tags = {
    Name = "ada-ec2-julio2"
  }
}

resource "aws_instance" "ada-ec2-julio3" {
  ami                    = "ami-063d43db0594b521b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = aws_subnet.privadaapp-c.id
  tags = {
    Name = "ada-ec2-julio3"
  }
}


