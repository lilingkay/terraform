# Create EC2 instance
resource "aws_vpc" "main" {
  cidr_block = "11.0.0.0/16"

  tags = {
    Name = "skillup-malcedo-terraform-vps"
    GBL_CLASS_0 = "Service"
    GBL_CLASS_1 = "Test"
  }

}