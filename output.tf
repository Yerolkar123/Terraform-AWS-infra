output "elb-dns-name" {
    value = "${aws_lb.application_lb.dns_name}" 
}
output igw_id {
  value = aws_internet_gateway.igw.id
}
output "vpc_id" {
    value = aws_vpc.demo_vpc.id
}