variable "project_name" {
  description = "Project repository prefix"
  type        = string
}

variable "services" {
  description = "Service names requiring image repositories"
  type        = set(string)
}