provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-02dfbd4ff395f2a1b"   # Amazon Linux AMI
  instance_type = "t2.micro"

  tags = {
    Name = "MyTerraformEC2"
  }
}
