resource "azurerm_servicebus_namespace" "asbembark" {
  name                = var.service_bus_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  local_auth_enabled  = false
  minimum_tls_version = "1.2"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_servicebus_namespace_authorization_rule" "asbembark-rule1" {
  name         = var.service_bus_authrule
  namespace_id = azurerm_servicebus_namespace.asbembark.id

  listen = true
  send   = true
  manage = false
}

resource "azurerm_servicebus_topic" "asbembark-topic1" {
  name         = var.service_bus_topicname
  namespace_id = azurerm_servicebus_namespace.asbembark.id

  # enable_partitioning = true #  The property 'enable_partitioning' has been superseded by 'partitioning_enabled' and will be removed in v4.0 of the AzureRM Provider.
  partitioning_enabled = true

}

resource "azurerm_role_assignment" "asb-dataowner-assignment" {
  scope                = azurerm_servicebus_namespace.asbembark.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = var.embark_asb_dataowner
}