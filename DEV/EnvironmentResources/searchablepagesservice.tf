resource "azurerm_user_assigned_identity" "searchablepages" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "${var.regionCode}${var.appname}${var.envCode}searchablepagesidentity"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_user_assigned_identity" "searchablepagesadmin" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "${var.regionCode}${var.appname}${var.envCode}searchablepagesadminidentity"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_user_assigned_identity" "searchablepagessite" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "${var.regionCode}${var.appname}${var.envCode}searchablepagessiteidentity"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_federated_identity_credential" "searchablepages-fic" {
  name                = "searchablepages-fic"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_url
  parent_id           = azurerm_user_assigned_identity.searchablepages.id
  subject             = "system:serviceaccount:${var.namespace}:searchablepages-sa"
}

resource "azurerm_federated_identity_credential" "searchablepages-fic-admin" {
  name                = "searchablepages-admin-fic"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_url
  parent_id           = azurerm_user_assigned_identity.searchablepagesadmin.id
  subject             = "system:serviceaccount:${var.namespace}:searchablepages-admin-sa"
}

resource "azurerm_federated_identity_credential" "searchablepages-fic-site" {
  name                = "searchablepages-site-fic"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_url
  parent_id           = azurerm_user_assigned_identity.searchablepagessite.id
  subject             = "system:serviceaccount:${var.namespace}:searchablepages-site-sa"
}

resource "azurerm_federated_identity_credential" "searchablepages-ficdr" {
  name                = "searchablepages-ficdr"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_failover_url
  parent_id           = azurerm_user_assigned_identity.searchablepages.id
  subject             = "system:serviceaccount:${var.namespace}:searchablepages-sa"
}

resource "azurerm_federated_identity_credential" "searchablepages-ficdr-admin" {
  name                = "searchablepages-admin-ficdr"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_failover_url
  parent_id           = azurerm_user_assigned_identity.searchablepagesadmin.id
  subject             = "system:serviceaccount:${var.namespace}:searchablepages-admin-sa"
}

resource "azurerm_federated_identity_credential" "searchablepages-ficdr-site" {
  name                = "searchablepages-site-ficdr"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_failover_url
  parent_id           = azurerm_user_assigned_identity.searchablepagessite.id
  subject             = "system:serviceaccount:${var.namespace}:searchablepages-site-sa"
}

resource "azurerm_role_assignment" "searchablepages-config-reader-assignment" {
  scope                = azurerm_app_configuration.appconfembark.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_user_assigned_identity.searchablepages.principal_id
}

resource "azurerm_role_assignment" "searchablepages-admin-config-reader-assignment" {
  scope                = azurerm_app_configuration.appconfembark.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_user_assigned_identity.searchablepagesadmin.principal_id
}

resource "azurerm_role_assignment" "searchablepages-site-config-reader-assignment" {
  scope                = azurerm_app_configuration.appconfembark.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_user_assigned_identity.searchablepagessite.principal_id
}

resource "azurerm_role_assignment" "searchablepages-asb-owner-assignment" {
  scope                = azurerm_servicebus_namespace.asbembark.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_user_assigned_identity.searchablepages.principal_id
}

resource "azurerm_role_assignment" "searchablepages-admin-asb-owner-assignment" {
  scope                = azurerm_servicebus_namespace.asbembark.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_user_assigned_identity.searchablepagesadmin.principal_id
}

resource "azurerm_role_assignment" "searchablepages-site-asb-owner-assignment" {
  scope                = azurerm_servicebus_namespace.asbembark.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_user_assigned_identity.searchablepagessite.principal_id
}

output "searchablepages_identity_resource_id" {
  value = azurerm_user_assigned_identity.searchablepages.id
}

output "searchablepages_identity_resource_clientId" {
  value = azurerm_user_assigned_identity.searchablepages.client_id
}

output "searchablepages_identity_resource_clientId_admin" {
  value = azurerm_user_assigned_identity.searchablepagesadmin.client_id
}

output "searchablepages_identity_resource_clientId_site" {
  value = azurerm_user_assigned_identity.searchablepagessite.client_id
}

# grant searchablepages MI
resource "azurerm_key_vault_access_policy" "kvsearchablepagesmi" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = azurerm_user_assigned_identity.searchablepages.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_key_vault_access_policy" "kvsearchablepagesadminmi" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = azurerm_user_assigned_identity.searchablepagesadmin.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_key_vault_access_policy" "kvsearchablepagessitesmi" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = azurerm_user_assigned_identity.searchablepagessite.principal_id

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_mssql_database" "searchablepagesDbName" {
  name            = "Embark_SearchablePages"
  server_id       = azurerm_mssql_server.sqlserver.id
  elastic_pool_id = azurerm_mssql_elasticpool.sqlep.id
  sku_name        = "ElasticPool"
  collation       = "SQL_Latin1_General_CP1_CI_AS" # change as needed
  max_size_gb     = var.sql_max_size_gb_integer    # integer
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
    ignore_changes = [long_term_retention_policy[0].week_of_year, tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }

  short_term_retention_policy {
    retention_days = 7
  }
}
