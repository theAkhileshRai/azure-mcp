# https://www.terraform.io/docs/providers/azurerm/r/sql_database.html
# DR does not need this resource created, will be a SQL failover group instead
resource "azurerm_sql_database" "configuration" {
  name                             = "Configuration"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.sqlsrv.name
  edition                          = var.sql_edition
  collation                        = var.sql_collation
  max_size_bytes                   = var.sql_max_size_bytes
  requested_service_objective_name = var.sql_requested_service_objective_name_configuration
  lifecycle {
    prevent_destroy = true
  }

  tags = local.appx_tags
}

resource "azurerm_sql_database" "prioritynotificationcenter" {
  name                             = "PriorityNotificationCenter"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.sqlsrv.name
  edition                          = var.sql_edition
  collation                        = var.sql_collation
  max_size_bytes                   = var.sql_max_size_bytes
  requested_service_objective_name = var.sql_requested_service_objective_name
  lifecycle {
    prevent_destroy = true
  }
  tags = local.appx_tags
}

resource "azurerm_sql_database" "appproviderdb" {
  name                             = "AppProviderDB"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.sqlsrv.name
  edition                          = var.sql_edition
  collation                        = var.sql_collation
  max_size_bytes                   = var.sql_max_size_bytes
  requested_service_objective_name = var.sql_requested_service_objective_name
  lifecycle {
    prevent_destroy = true
  }
  tags = local.appx_tags
}