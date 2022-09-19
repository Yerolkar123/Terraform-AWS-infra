resource "aws_vpc" "demo_vpc" {
  vpc_id = aws_vpc.demo_vpc.id 
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "demo_vpc" 
  } 
}
resource "aws_subnet_ids" "Public_subnet" {
  vpc_id = aws_vpc.demo_vpc.id 
  cidr_block = "10.0.0.0/24" 
  map_public_ip_on_lunch = "true" 
  availability_zone = "us-east-1a"
    
  tags = {
    Name = "Public_subnet" 
    }
  } 

resource "aws_subnet_ids" "Private_subnet" {
  vpc_id = aws_vpc.demo_vpc.id 
  cidr_block = "10.0.1.0/24" 
  map_public_ip_on_lunch = "false" 
  availability_zone = "us-east-1a"
    
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
  vpc_id = aws_vpc.demo_vpc 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw 
  }
  
  tags = {
    Name = "public" 
  }
} 
resource "aws_route_table" "Private_route" { 
  vpc_id = aws_vpc.demo_vpc 

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
  depends_on = [aws_internet_gateway.igw] 
  tags = {
    Name = "nat_gateway_eip" 
  }
} 
resource "aws_nat_gateway" "demo_nat" {
  allocatallocation_id =  aws_eip.nat_eip
  subnet_id = aws_subnet_ids.Public_subnet
  
  tags = {
    Name = "nat_gateway_eip" 
  }
} 