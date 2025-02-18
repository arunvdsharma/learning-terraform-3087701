data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "blog-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1", "us-east-2"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "blog_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "blog_web"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.public_subnets[0]

  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = [module.blog_sg.security_group_id]
  tags = {
    Name = "HelloWorld"
  }
}