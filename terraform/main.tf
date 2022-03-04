terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51.0"
    }
  }
}
provider "aws" {
  region = var.region
}

resource "aws_instance" "contest_simulation" {
  launch_template {
    name = "contest-simulator-template"
  }
  associate_public_ip_address = true

  tags = {
    Name = "ContestSimulator"
  }
}

output "public_ip" {
  value = aws_instance.contest_simulation.public_ip
}
