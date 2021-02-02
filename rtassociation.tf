resource "aws_route_table_association" "Private" {
  subnet_id      = aws_subnet.Private_Subnet.id
  route_table_id = aws_route_table.Private.id
}

resource "aws_route_table_association" "Public" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Public.id
}
