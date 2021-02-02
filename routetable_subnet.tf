resource "aws_route_table" "Private" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "Private Subnet Route Table"
  }

}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "Public Subnet Route Table"
  }

}
