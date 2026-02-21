variable "ami_id" {
  description = "AMI ID to use for all instances"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}
