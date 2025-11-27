provider "azurerm" {
  features {}
}

provider "azuread" {
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }

  backend "azurerm" {
  }
}