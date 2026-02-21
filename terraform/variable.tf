variable "ami_id" {
  description = "AMI ID to use for all instances"
  type        = string
  default         = "ami-09256c524fab91d36"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "db_password" {
  type = string
}