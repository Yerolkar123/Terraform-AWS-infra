output "elb-dns-name" {
    value = "${aws_lb.application_lb.dns_name}" 
}