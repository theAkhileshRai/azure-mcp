resource "azurerm_user_assigned_identity" "environment" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "${var.regionCode}${var.appname}${var.envCode}environmentidentity"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_federated_identity_credential" "environment-fic" {
  name                = "environment-fic"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_url
  parent_id           = azurerm_user_assigned_identity.environment.id
  subject             = "system:serviceaccount:${var.namespace}:environment-sa"
}

resource "azurerm_federated_identity_credential" "environment-ficdr" {
  name                = "environment-ficdr"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_failover_url
  parent_id           = azurerm_user_assigned_identity.environment.id
  subject             = "system:serviceaccount:${var.namespace}:environment-sa"
}

resource "azurerm_role_assignment" "environment-config-reader-assignment" {
  scope                = azurerm_app_configuration.appconfembark.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_user_assigned_identity.environment.principal_id
}

output "environment_identity_resource_id" {
  value = azurerm_user_assigned_identity.environment.id
}

output "environment_identity_resource_clientId" {
  value = azurerm_user_assigned_identity.environment.client_id
}

# grant environment MI
resource "azurerm_key_vault_access_policy" "kvenvironmentmi" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = azurerm_user_assigned_identity.environment.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_mssql_database" "EnvironmentDbName" {
  name            = "Embark_Environment"
  server_id       = azurerm_mssql_server.sqlserver.id
  elastic_pool_id = azurerm_mssql_elasticpool.sqlep.id
  sku_name        = "ElasticPool"
  collation       = "SQL_Latin1_General_CP1_CI_AS" # change as needed
  zone_redundant  = var.sql_zone_redundant_bool

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  long_term_retention_policy {
    weekly_retention = "P6W" # retain for 6 weeks
    week_of_year     = 1     # required, see: https://github.com/terraform-providers/terraform-provider-azurerm/issues/9318
  }

  lifecycle {
    ignore_changes = [long_term_retention_policy[0].week_of_year, tags["billingbusiness"], tags["business"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }

  short_term_retention_policy {
    retention_days = 7
  }
}