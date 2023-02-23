# Create vpc instance
resource "aws_vpc" "skillup-malcedo-terraform-vpc" {
  cidr_block = "11.0.0.0/16"


  tags = {
    Name = "skillup-malcedo-terraform-vpc"
    GBL_CLASS_0 = "Service"
    GBL_CLASS_1 = "Test"
  }
}