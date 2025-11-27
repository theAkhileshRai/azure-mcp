data "azurerm_resource_group" "group" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "operator-assignment" {
  scope                = data.azurerm_resource_group.group.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.k8s_managed_id
}