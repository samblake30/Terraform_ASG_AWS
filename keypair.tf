#Creation of the Key-Pair

resource "aws_key_pair" "Key_Pair" {
  key_name   = "rke"
  public_key = var.keypair

  tags = {
    Name = "RKE"
  }
}
