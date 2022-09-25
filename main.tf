
resource "aws_key_pair" "keyfile" {
    
  key_name   = "keyfile"
  public_key = file("keyfile.pub")
  tags       = {
  Name = "keyfile"
  }
}

data "aws_availability_zones" "az" {

state = "available"

}
resource "aws_vpc" "demo_vpc" {
  vpc_id = aws_vpc.demo_vpc.id 
  cidr_block = "${var.vpc_cidr}"
  enable_nat_gateway = true
  tags = {
    Name = "demo_vpc" 
  } 
}
resource "aws_subnet_ids" "Public_subnet" {
  vpc_id = aws_vpc.demo_vpc.id 
  cidr_block = "${ var.Public_cidr }" 
  map_public_ip_on_lunch = "true" 
  availability_zone = data.aws_availability_zones.az.names[0]
    
  tags = {
    Name = "Public_subnet" 
    }
  } 

resource "aws_subnet_ids" "Private_subnet" {
  vpc_id = aws_vpc.demo_vpc.id 
  cidr_block = "${var.Private_cidr}" 
  map_public_ip_on_lunch = "false" 
  availability_zone = data.aws_availability_zones.az.names[0]
    
  tags = {
    Name = "Private_subnet" 
    }
  }
resource "aws_internet_gateway" "demo_igw" { 
  vpc_id = aws_vpc.demo_vpc.id 
  
  tags = {
    Name = "Demo_igw"
  }
  
} 
resource "aws_route_table" "Public_route" { 
  vpc_id = aws_vpc.demo_vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw 
  }
  
  tags = {
    Name = "public" 
  }
} 
resource "aws_route_table" "Private_route" { 
  vpc_id = aws_vpc.demo_vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_nat_gateway.demo_nat
  }
  
  tags = {
    Name = "private" 
  }
} 
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet_ids.Public_subnet.id 
  route_table_id = aws_route_table.Public_route
} 
resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet_ids.Private_subnet.id 
  route_table_id = aws_route_table.Private_route
} 
resource "aws_eip" "nat_eip" {
  vpc = "true"  
  depends_on = [aws_internet_gateway.demo_igw] 
  tags = {
    Name = "nat_gateway_eip" 
  }
} 
resource "aws_nat_gateway" "demo_nat" {
  allocation_id =  aws_eip.nat_eip
  subnet_id = aws_subnet_ids.Public_subnet
  
  tags = {
    Name = "nat_gateway_eip" 
  }
} 

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.demo_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_default_vpc.main.cidr_blocks]
    }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_default_vpc.main.cidr_blocks]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "web-server" {
  ami           = "${var.image_id}"
  instance_type = "${var.machine_type}"
  region        = "${var.region}"
  security_group = data.aws_security_group.allow_tls.name
  key_name      = "${var.key_name}"
  count         = 2 
  vpc_id         =  data.aws_vpc.demo_vpc.id 
  subnet_id      =  data.aws_subnet_ids.Public_subnet
  associate_public_ip_address =  true

  tags = { 
    Name = "Public-instance"  
}   
} 
resource "aws_instance" "DB_server" {
  ami            = "${var.image_id}"
  instance_type  = "${var.machine_type}"
  region         = "${var.region}"
  security_group = data.aws_security_group.allow_tls.name
  key_name       = "${var.key_name}"
  vpc_id         =  data.aws_vpc.demo_vpc.id 
  subnet_id      =  data.aws_subnet_ids.Private_subnet
  count          =  1
  associate_public_ip_address =  false

  tags = {
    Name = "private-instance"
  }
}