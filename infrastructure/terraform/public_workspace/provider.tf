# Configure the Microsoft Azure Provider
terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.99.0"
    }

    azureml = {
      source = "registry.terraform.io/orobix/azureml"
    }
  }

}
provider "azurerm" {
  skip_provider_registration = "true"
  features {}

}
