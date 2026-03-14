resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "dev-vpc"
    }
  
}


resource "aws_subnet" "public" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "dev-public-subnet"
    }
  
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "dev-private-subnet"
    }
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "dev-igw"
    }
  
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "dev-nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "dev-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "dev" {
    vpc_id = aws_vpc.dev.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "dev" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.dev.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "dev-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "dev" {
    name = "dev-sg"
    description = "Allow SSH and HTTP traffic"
    vpc_id = aws_vpc.dev.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]    
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "dev" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.dev.id]
    tags = {
      Name = "dev-ec2"
    }
  
}