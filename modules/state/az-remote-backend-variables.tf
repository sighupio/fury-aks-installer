# Company variable
variable "company" {
  type        = string
  description = "This variable defines the name of the company"

  # Default value set to "fury"
  default = "fury"
}

# Environment variable
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"

  # Default value set to "development"
  default = "development"
}

# Azure location variable
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"

  # Default value set to "westeurope"
  default = "westeurope"
}
