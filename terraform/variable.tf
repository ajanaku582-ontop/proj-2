variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the instances"
  default     = "ami-09040d770ffe2224f" # Amazon Linux 2023 in us-east-2
}

variable "key_name" {
  type        = string
  description = "The name of the AWS Key Pair to use"
}

variable "db_password" {
  type        = string
  description = "Password for the RDS instance"
  sensitive   = true
}