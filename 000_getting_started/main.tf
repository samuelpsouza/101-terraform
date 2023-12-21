terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "instance_type" {
  type = string
  default = "t2.nano"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-079db87dc4c10ac91"
  instance_type = var.instance_type

  tags = {
    Name = "app_server"
  }

}