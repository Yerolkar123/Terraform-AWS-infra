variable "region" {
    description = "my_region"
    default = "us-east-1"
}
variable "image_id" {
    default = ""
}
variable "key_name" {
   default = "demo-ec2"
}
variable "var.machine_type" {
    default = "t2.micro"
}
variable "vpc_cidr" {
    default = "10.0.0.0/30"
}
variable "Public_cidr" {
    default = "10.0.0.14/30" 
}
variable "Private_cidr" {
    default = 	"10.0.0.13/30"
}
# Bucket  name 
/*
variable "s3_bucket_name" {
    description = "s3_bucket_name"
    type = string
    default = "202i0ike"
}
*/
