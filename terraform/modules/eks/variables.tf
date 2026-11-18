variable "project_name" {
  description = "Project resource name prefix"
  type        = string
}
variable "private_subnet_ids" {
  description = "Two private subnet IDs in different Availability Zones"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) == 2
    error_message = "Exactly two private subnet IDs are required."
  }
}

variable "admin_cidr" {
  description = "Public IPv4 CIDR allowed to access the Kubernetes API"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.35"
}
