resource "azurerm_user_assigned_identity" "standard" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "${var.regionCode}${var.appname}${var.envCode}standardidentity"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_federated_identity_credential" "standard-fic" {
  name                = "standard-fic"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_url
  parent_id           = azurerm_user_assigned_identity.standard.id
  subject             = "system:serviceaccount:${var.namespace}:standard-sa"
}

resource "azurerm_federated_identity_credential" "standard-ficdr" {
  name                = "standard-ficdr"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_failover_url
  parent_id           = azurerm_user_assigned_identity.standard.id
  subject             = "system:serviceaccount:${var.namespace}:standard-sa"
}

resource "azurerm_role_assignment" "standard-config-reader-assignment" {
  scope                = azurerm_app_configuration.appconfembark.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_user_assigned_identity.standard.principal_id
}

output "standard_identity_resource_clientId" {
  value = azurerm_user_assigned_identity.standard.client_id
}

# grant standard MI
resource "azurerm_key_vault_access_policy" "kvstandardmi" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = azurerm_user_assigned_identity.standard.principal_id

  secret_permissions = [
    "Get"
  ]
}