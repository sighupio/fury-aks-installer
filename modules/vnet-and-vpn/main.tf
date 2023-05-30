# Terraform configuration file
# Specifies the required version of Terraform and the required providers
# 
# Terraform Version: 1.3.0
# azurerm Provider Version: 3.44.1
# local Provider Version: 2.0.0
# null Provider Version: 3.0.0
# external Provider Version: 2.0.0
# template Provider Version: 2.2.0
# random Provider Version: 3.4.3
#
# Features block is empty

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.44.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}