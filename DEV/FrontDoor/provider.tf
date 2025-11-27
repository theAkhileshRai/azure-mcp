provider "azurerm" {
  features {
  }
}

provider "azurerm" {
  alias           = "embarkdns"
  subscription_id = "c6329ed4-d5bb-40ae-bd8f-297e621cd901"

  features {
  }
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {}
}
