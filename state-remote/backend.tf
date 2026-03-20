terraform {
  backend "s3" {
    bucket = "maggie-devops-aws"
    key = "terraform.tfstate"
    region = "us-east-1"
    
  }
}