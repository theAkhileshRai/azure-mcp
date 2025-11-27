resource "azurerm_key_vault" "kvprojectex" {
  name                        = "${local.regioncodeprefix}projectex${var.env_code}kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  # Tenant ID is AD ID for Willis Towers Watson
  tenant_id                = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  sku_name                 = "standard" # or "premium"
  purge_protection_enabled = true

  # default only allow Azure  WTW networks and whatever else. 
  # commented out for now
  /*
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules = ["32.66.102.170","32.66.102.171","32.66.102.172","32.66.102.173","32.66.102.174","32.66.114.161","32.66.114.162",   "32.66.114.163","32.66.114.164","32.66.114.165","32.65.74.146","32.65.74.147","32.65.74.148","32.65.74.149","32.65.74.150","158.82.143.130","158.82.159.130","202.167.233.229","27.111.213.117","41.242.168.121","52.254.79.207","52.247.126.178","52.168.82.81","52.177.0.71","52.177.116.166","89.28.187.5","89.28.187.6","89.28.187.7","89.28.187.8","89.28.187.9","89.28.187.10","89.28.187.11","89.28.187.12","158.82.143.120","158.82.159.120"]

  }
  */

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [network_acls]
  }
  tags = local.appx_tags

}

# grant GDT_DevOps_Adm
resource "azurerm_key_vault_access_policy" "kvprojectex" {
  key_vault_id = azurerm_key_vault.kvprojectex.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = "6381f357-db3a-46ac-bff9-c0d0d9a54448"

  key_permissions = [
    "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore"
  ]

  secret_permissions = [
    "get", "list", "set", "delete", "recover", "backup", "restore"
  ]

  certificate_permissions = [
    "backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "recover", "restore", "setissuers", "update"
  ]
}

# grant b2cext app service; exported values (https://www.terraform.io/docs/providers/azurerm/r/app_service.html)
resource "azurerm_key_vault_access_policy" "kvprojectexb2cext" {
  key_vault_id = azurerm_key_vault.kvprojectex.id
  tenant_id    = azurerm_app_service.b2cext.identity.0.tenant_id
  object_id    = azurerm_app_service.b2cext.identity.0.principal_id

  key_permissions = [
    "get", "list"
  ]

  secret_permissions = [
    "get", "list"
  ]

  certificate_permissions = [
    "get", "list"
  ]
}
