resource "aws_route" "Public_Internet_Gateway" {
  route_table_id         = aws_route_table.Public.id
  destination_cidr_block = var.rtpub
  gateway_id             = aws_internet_gateway.ig.id
  depends_on             = [aws_route_table.Public]
}

resource "aws_route" "Private_NAT_Gateway" {
  route_table_id         = aws_route_table.Private.id
  destination_cidr_block = var.rtpri
  nat_gateway_id         = aws_nat_gateway.nat.id
  depends_on             = [aws_route_table.Private]
}
