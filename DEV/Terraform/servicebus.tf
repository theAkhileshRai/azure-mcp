/*
    https://www.terraform.io/docs/providers/azurerm/r/servicebus_namespace.html
*/

resource "azurerm_servicebus_namespace" "servicebus" {
  name                = var.servicebus_namespace
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.servicebus_sku
  # minimum_tls_version = "1.2"

  tags = local.sa_tags
}
