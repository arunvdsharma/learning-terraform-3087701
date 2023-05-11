output "ec2_instance_ami" {
  value = aws_instance.blog.ami
}

output "ec2_instance_arn" {
  value = aws_instance.blog.arn
}
