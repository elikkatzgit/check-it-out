resource "aws_vpc" "check-vpc" {
  cidr_block           = "10.20.30.40/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "check"
  }
}
