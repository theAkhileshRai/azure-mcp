# https://www.terraform.io/docs/providers/azurerm/r/sql_server.html
resource "azurerm_sql_server" "sqlsrv" {
  name                         = "${local.regioncodeprefix}${var.env_code}sqlsrv"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_login_password

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [identity, threat_detection_policy]
  }
  tags = local.appx_tags
}
