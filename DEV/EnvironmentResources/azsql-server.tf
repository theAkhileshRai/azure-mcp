# SQL server only
resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0" # see https://gorandalf.wordpress.com/2020/09/27/azure-sql-database-compatibility-with-sql-server/
  administrator_login          = "dbadmin"
  administrator_login_password = var.sql_administrator_login_password
  minimum_tls_version          = "1.2"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  azuread_administrator {
    login_username              = var.sql_admin_group_name
    object_id                   = var.sql_admin_group_object_id
    azuread_authentication_only = var.sql_azuread_authentication_only
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}
