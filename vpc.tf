resource "aws_vpc" "my_vpc" {
 
  name = "first-vpc"
  cidr = "10.0.0.0/16"
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
resource "aws_security_group" "aws_sg" {
    name = "my_sg"
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        from_port = 8080
        to_port   = 8080
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
