output "vpc_id" {
  description = "ID of project VPC"
  value       = data.aws_vpc.my_vpc.id
}
