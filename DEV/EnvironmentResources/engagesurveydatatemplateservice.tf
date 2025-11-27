resource "azurerm_user_assigned_identity" "engagesurveydatatemplate" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "${var.regionCode}${var.appname}${var.envCode}engagesurveydatatemplateidentity"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_federated_identity_credential" "engagesurveydatatemplate-fic" {
  name                = "engagesurveydatatemplate-fic"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_url
  parent_id           = azurerm_user_assigned_identity.engagesurveydatatemplate.id
  subject             = "system:serviceaccount:${var.namespace}:engagesurveydatatemplate-sa"
}

resource "azurerm_federated_identity_credential" "engagesurveydatatemplate-ficdr" {
  name                = "engagesurveydatatemplate-ficdr"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_failover_url
  parent_id           = azurerm_user_assigned_identity.engagesurveydatatemplate.id
  subject             = "system:serviceaccount:${var.namespace}:engagesurveydatatemplate-sa"
}

resource "azurerm_role_assignment" "engagesurveydatatemplate-config-reader-assignment" {
  scope                = azurerm_app_configuration.appconfembark.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_user_assigned_identity.engagesurveydatatemplate.principal_id
}

resource "azurerm_role_assignment" "engagesurveydatatemplate-asb-owner-assignment" {
  scope                = azurerm_servicebus_namespace.asbembark.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_user_assigned_identity.engagesurveydatatemplate.principal_id
}

output "engagesurveydatatemplate_identity_resource_clientId" {
  value = azurerm_user_assigned_identity.engagesurveydatatemplate.client_id
}

# grant engagesurveydatatemplate MI
resource "azurerm_key_vault_access_policy" "kvengagesurveydatatemplatemi" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = azurerm_user_assigned_identity.engagesurveydatatemplate.principal_id

  secret_permissions = [
    "Get"
  ]
}

# create database EngageSurveymbark_DataTemplate
resource "azurerm_mssql_database" "engagesurveydatatemplateDbName" {
  name            = "EngageSurvey_Data"
  server_id       = azurerm_mssql_server.sqlserver.id
  elastic_pool_id = azurerm_mssql_elasticpool.sqlep.id
  sku_name        = "ElasticPool"
  collation       = "SQL_Latin1_General_CP1_CI_AS" # change as needed
  max_size_gb     = var.sql_max_size_gb_integer    # integer
  zone_redundant  = var.sql_zone_redundant_bool
  enclave_type    = var.enclave_type

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
