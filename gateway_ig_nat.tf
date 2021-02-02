#Creating Internet Gateway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "Internet Gateway for Public"
  }
}

#Creating NAT Gateway

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.Public_Subnet.id
  depends_on    = [aws_internet_gateway.ig]

  tags = {
    Name = "NAT Gateway for Private"
  }
}
