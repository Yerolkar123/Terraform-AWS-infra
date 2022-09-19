resource "aws_instance" "web-server" {
  ami           = "data.aws_ami.ubuntu.id"
  instance_type = "t2.micro" 
  region        = "${var.region}"
  security_group = ["${aws_security_group.allow_tls.name}"] 
  key_name = "key-1" 
  count    = 2 
  vpc_id         =  data.aws_vpc.demo_vpc.id 
  subnet_id      =  data.aws_subnet_ids.Public_subnet
  associate_public_ip_address =  true

  tags = { 
    Name = "Private-instance"  
}   
} 

resource "aws_instance" "DB_server" {
  ami            = "data.aws_ami.ubuntu.id" 
  instance_type  = "t2.micro" 
  region         = "${var.region}"
  security_group = ["${aws_security_group.allow_tls.name}"] 
  key_name       = "key-1" 
  vpc_id         =  data.aws_vpc.demo_vpc.id 
  subnet_id      =  data.aws_subnet_ids.Private_subnet
  count          =  1
  associate_public_ip_address =  false

  tags = {
    Name = "private-instance"
  }
}


/*
resource "aws_instance" "public_ec2" {
  ami            = "data.aws_ami.ubuntu.id" 
  instance_type  = "t2.micro" 
  security_group = ["${aws_security_group.allow_tls.name}"] 
  key_name       = "key-1" 
  vpc_id         =  aws_vpc.demo_vpc.id 
  subnet_id      =  aws_subnet_ids.Public_subnet
  count          =  1
  associate_public_ip_address =  true

  tags = {
    Name = "public-instance"
  }
} 

*/