output "ec2_public_ip" {
  value = aws_instance.sample-vm[0].public_ip
}
output "ec2_private_ip" {
  value = aws_instance.sample-vm[0].private_ip
}
