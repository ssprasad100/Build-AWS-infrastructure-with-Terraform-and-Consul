variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}


variable "aws_amis" {
  default = {
    eu-west-1 = "ami-408c7f28"
    us-east-1 = "ami-408c7f28"
    us-west-1 = "ami-408c7f28"
    us-west-2 = "ami-408c7f28"
  }
}
