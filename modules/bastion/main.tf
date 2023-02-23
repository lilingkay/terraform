# Create EC2 instance
resource "aws_instance" "skillup-malcedo-terraform" {
  ami = "ami-05375ba8414409b07"
  instance_type = "t3.micro"
  key_name = "skillup-keypair"

  tags = {
    "GBL_CLASS_0" = "Service"
    "GBL_CLASS_1" = "Test"
    "Project" = "COT"

  }
  
}