output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.my_vpc.id
}
