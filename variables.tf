variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances
  type        = string
  default     = "ami-0ecb62995f68bb549"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}
