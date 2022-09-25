resource "aws_vpc" "demo_vpc" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "demo_vpc" 
  } 
}
resource "aws_subnet" "Public_subnet" {
  vpc_id = aws_vpc.demo_vpc.id 
  cidr_block = "${ var.Public_cidr_block }" 
  map_public_ip_on_launch = "true" 
  availability_zone = data.aws_availability_zones.az.names[0]
    
  tags = {
    Name = "Public_subnet" 
    }
  } 

resource "aws_subnet" "Private_subnet" {
  vpc_id = aws_vpc.demo_vpc.id 
  cidr_block = "${var.Private_cidr_block}" 
  map_public_ip_on_launch = "false" 
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
    gateway_id = aws_internet_gateway.demo_igw.id
  }
  
  tags = {
    Name = "public" 
  }
} 
resource "aws_route_table" "Private_route" { 
  vpc_id = aws_vpc.demo_vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_nat_gateway.demo_nat.id
  }
  
  tags = {
    Name = "private" 
  }
} 
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.Public_subnet.id 
  route_table_id = aws_route_table.Public_route
} 
resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.Private_subnet.id 
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
  allocation_id =  aws_eip.nat_eip.id
  subnet_id = aws_subnet.Public_subnet.id
  
  tags = {
    Name = "nat_gateway_eip" 
  }
} 

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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
  instance_type = "${var.instance_type}"
  security_groups = aws_security_group.allow_tls.name 
  count         = 2 
  subnet_id      =  aws_subnet.Public_subnet.id
  associate_public_ip_address =  true

  tags = { 
    Name = "Public-instance"  
}   
} 
resource "aws_instance" "DB_server" {
  ami            = "${var.image_id}"
  instance_type  = "${var.instance_type}"
  security_groups = aws_security_group.allow_tls.name
  subnet_id      =  aws_subnet.Private_subnet
  count          =  1
  associate_public_ip_address =  false

  tags = {
    Name = "private-instance"
  }
}
