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
    default = "172.31.0.0/20"
}
variable "Public_subA_cidr_block" {
    default = "172.31.32.0/32" 
}
variable "Public_subB_cidr_block" {
    default = "172.31.16.0/32" 
}
variable "Private_cidr_block" {
    default = 	"172.31.32.5/32"
}
