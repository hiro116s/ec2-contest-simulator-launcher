variable "region" {
  description = "The region Terraform deploys your instance"
}

variable "key_path" {
  description = "The path to the key for connecting to server"
}

variable "instance_type" {
  default     = "t2.small"
  description = "Instance type for running simulation in AWS"
}
