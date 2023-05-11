output "ec2_instance_ami" {
  value = aws_instance.web.ami
}

output "ec2_instance_arn" {
  value = aws_instance.web.arn
}
