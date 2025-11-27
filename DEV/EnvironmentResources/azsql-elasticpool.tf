# vcore based model
# https://www.terraform.io/docs/providers/azurerm/r/mssql_elasticpool.html

# assumes resource of azurerm_mssql_server.sqlserver is created

resource "azurerm_mssql_elasticpool" "sqlep" {
  server_name         = azurerm_mssql_server.sqlserver.name
  name                = var.sql_elastic_pool_name
  resource_group_name = var.resource_group_name
  location            = var.location
  max_size_gb         = var.sql_max_size_gb_integer
  zone_redundant      = var.sql_zone_redundant_bool
  license_type        = var.sql_license_type # "LicenseIncluded" / "BasePrice"

  # see see https://docs.microsoft.com/en-us/azure/sql-database/sql-database-vcore-resource-limits-elastic-pools
  sku {
    tier     = var.sql_sku_tier     # GeneralPurpose, BusinessCritical
    name     = var.sql_sku_name     # e.g. GP, BC; will set to GP_Gen5 or BC_Gen5
    capacity = var.sql_sku_capacity # integer multiple of 2; see: https://docs.microsoft.com/en-us/azure/sql-database/sql-database-vcore-resource-limits-elastic-pools#general-purpose---provisioned-compute---gen5
    family   = "Gen5"               # Gen4, Gen5
  }

  per_database_settings {
    # integer; .25 = 1/4 , etc.
    min_capacity = var.sql_min_capacity_integer
    max_capacity = var.sql_sku_capacity
  }

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}
