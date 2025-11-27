# Resource group
# This TF file will mostly be used for RBAC permissions on the resource group level

resource "azurerm_role_assignment" "projectexdnn_resourceGroup_hbCloudGovernanceServicePrincipal" {
  role_definition_name = "Resource Policy Contributor"
  scope = data.azurerm_resource_group.pex_resource_group.id
  principal_id = var.hbcloudgovernance_serviceprincipal_objectid
}