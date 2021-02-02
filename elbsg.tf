#This security group is for the ELB

resource "aws_security_group" "elbsg" {
  vpc_id = aws_vpc.My_VPC.id

  dynamic "ingress" {
    for_each = var.elbsgingress_port
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.elbcidr
    }

  }

  tags = {
    Name        = "Elastic Load Balancer Security Group"
    Description = "Terraform ELB Security Group"
  }
  dynamic "egress" {
    for_each = var.sgelbegress_port
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = var.elbegresscidr
    }

  }

}
