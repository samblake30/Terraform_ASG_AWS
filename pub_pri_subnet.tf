#Creating the private subnet

resource "aws_subnet" "Private_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.prisubnetcidr
  map_public_ip_on_launch = false
  availability_zone       = var.az

  tags = {
    Name = "PRIVATE SUBNET"
  }

}

#Creating the Public subnet

resource "aws_subnet" "Public_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.pubsubnetcidr
  map_public_ip_on_launch = true
  availability_zone       = var.az

  tags = {
    Name = "PUBLIC SUBNET"
  }

}
