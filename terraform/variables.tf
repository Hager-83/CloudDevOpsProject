variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project resource name prefix"
  type        = string
  default     = "ivolve"
}

variable "admin_cidr" {
  description = "Administrator public IPv4 address with /32"
  type        = string
}