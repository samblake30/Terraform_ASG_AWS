#Creating the Security Group for the compute set

resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id = aws_vpc.My_VPC.id

  dynamic "ingress" {
    for_each = var.sgingress_port
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.cidr
    }

  }

  tags = {
    Name        = "Compute Security Group"
    Description = "Terraform Security Group"
  }
  dynamic "egress" {
    for_each = var.sgegress_port
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = var.egresscidr
    }
  }

}
