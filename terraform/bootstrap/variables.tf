variable "aws_region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique Terraform state bucket name"
  type        = string
  default     = "ivolve-tfstate-211017377170-us-east-1"
}