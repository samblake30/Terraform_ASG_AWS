resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.terraform_ami.id
  instance_type          = var.instance_type
  availability_zone      = var.az
  subnet_id              = aws_subnet.Public_Subnet.id
  vpc_security_group_ids = [aws_security_group.My_VPC_Security_Group.id]
  key_name               = aws_key_pair.Key_Pair.key_name

  tags = {
    Name = "BastionServer"
  }
}
