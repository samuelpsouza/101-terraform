locals {
  customer_name = "ssouza"
  project_name = "terraform-certification"
}


resource "aws_instance" "app_server" {
  ami           = "ami-079db87dc4c10ac91"
  instance_type = var.instance_type

  tags = {
    Name = "app_server_${local.customer_name}"
  }

}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.eu
  }

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
    Project = local.project_name
  }
}