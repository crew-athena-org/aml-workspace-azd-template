variable "deployment_name" {
  type        = string
  description = "Name of the deployment"
  default     = "MSProEUEI"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
  default     = ""
}

variable "location" {
  type        = string
  description = "Location of the resources"
  default     = "eastus2"
}
