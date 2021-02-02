#Create the VPC

resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpccidr
  instance_tenancy     = var.instancetenancy
  enable_dns_support   = var.dnssupport
  enable_dns_hostnames = var.dnshostname

  tags = {
    Name = "My VPC"
  }

}
