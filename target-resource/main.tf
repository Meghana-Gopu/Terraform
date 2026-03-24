resource "aws_s3_bucket" "name" {
    bucket = "meghana-terraform-s3-bucket"
  
}

resource "aws_instance" "name" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    tags = {
      name = "dev"
    }
  
}

#we can target specific resource to update or destory by using -target option in terraform plan and apply command
#terraform plan -target=aws_instance.name
#if multiple resources wecan use -target multiple times
#terraform plan -target=aws_instance.name -target=aws_s3_bucket.name
  
