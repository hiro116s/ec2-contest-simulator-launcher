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
    name = local.launch_template_name
  }
  associate_public_ip_address = true
  instance_type               = var.instance_type
  tags = {
    Name = "ContestSimulator"
  }
}

output "public_ip" {
  value = aws_instance.contest_simulation.public_ip
}

output "instance_id" {
  value = aws_instance.contest_simulation.id
}

output "launch_template_name" {
  value = local.launch_template_name
}

# Reference:
# https://stackoverflow.com/questions/62403030/terraform-wait-till-the-instance-is-reachable
# https://www.terraform.io/language/resources/provisioners/remote-exec
resource "null_resource" "wait_connection" {
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.contest_simulation.public_ip
      user        = "ubuntu"
      private_key = file(var.key_path)
    }

    inline = ["echo 'connected!'"]
  }
}

locals {
  launch_template_name = "contest-simulator-template"
}
