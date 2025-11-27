terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
  }

  # version 0.13 was separate provider for version configuation block. Since moved to required_providers per https://www.terraform.io/language/providers/requirements
  required_providers {
    azurerm = {
      version = ">= 2.0, <= 2.99.0"
    } # azurerm
    # https://www.terraform.io/docs/providers/random
    random = {
      version = ">= 2.0, <= 2.99.0"
    } # random
  }   # required_providers end
}

provider "azurerm" {
  features {}
}

