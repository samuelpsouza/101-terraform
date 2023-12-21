terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "instance_type" {
  type    = string
  default = "t2.nano"
}

locals {
  customer_name = "ssouza"
  project_name = "terraform-certification"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "aws" {
  profile = "default"
  region = "eu-west-1"
  alias = "eu"
}

resource "aws_instance" "app_server" {
  ami           = "ami-079db87dc4c10ac91"
  instance_type = var.instance_type

  tags = {
    Name = "app_server_${local.customer_name}"
  }

}

output "public_ip" {
  value = aws_instance.app_server.public_ip
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