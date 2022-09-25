variable "region"  {
    description = "my_region"
    default = "us-east-1"
}
variable "image_id" {
    default = "ami-0b3e423be2b1ed909"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}
variable "Public_cidr_block" {
    default = "10.0.0.0/24" 
}
variable "Private_cidr_block" {
    default = 	"10.0.1.0/24"
}
