output "ec2_public_ip" {
  value = aws_instance.portfolio.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.portfolio.public_dns
}

output "instance_id" {
  value = aws_instance.portfolio.id
}

output "key_name" {
  value = aws_key_pair.portfolio.key_name
}

output "private_key_pem" {
  value     = tls_private_key.portfolio.private_key_pem
  sensitive = true
}
