
# Log Analytics Workspace
# To get ID -> data.azurerm_log_analytics_workspace.logworkspace.workspace_id
data "azurerm_log_analytics_workspace" "logworkspace" {
  name                = var.loganalytics_workspace
  resource_group_name = var.loganalytics_resourcegroup
}

output "loganalytics_name" {
  value = var.loganalytics_workspace
}

output "loganalytics_rg" {
  value = var.loganalytics_resourcegroup
}

# Key Vault
# Get KeyVault ID -> data.azurerm_key_vault.example.id
# Get Certificate Thumbprint -> data.azurerm_key_vault_certificate.example.thumbprint
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_certificate
data "azurerm_key_vault" "pexkeyvault" {
  name                = var.keyvault
  resource_group_name = var.keyvault_resourcegroup
}

data "azurerm_key_vault_certificate" "pexcert" {
  name         = var.keyvault_certificate_name
  key_vault_id = data.azurerm_key_vault.pexkeyvault.id
}

# Resource Group
data "azurerm_resource_group" "pex_resource_group" {
  name = var.resource_group_name
}