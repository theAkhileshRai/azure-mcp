resource "azurerm_key_vault" "kvembark" {
  name                        = var.keyvault
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  # Tenant ID is AD ID for Willis Towers Watson
  tenant_id                = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  sku_name                 = "premium" # or "premium"
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

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

# grant GDT_DevOps_Adm
resource "azurerm_key_vault_access_policy" "kvembark" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = "6381f357-db3a-46ac-bff9-c0d0d9a54448"

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]

  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers", "Update"
  ]
}

# grant WWC-WTW TR Ops SW PC Product Architects
resource "azurerm_key_vault_access_policy" "kvproductarch" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = "df37ac84-dc7a-480d-8eb7-9cd6e2e4da5b"

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
}

# grant WWC-WTW TR Ops SW PC Product Team Leads
resource "azurerm_key_vault_access_policy" "kvproductTL" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = "edfbbcff-efac-49eb-bd5b-c77a86d1a375"

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
}

# grant MFE-Developers
resource "azurerm_key_vault_access_policy" "kvDevs" {
  count        = var.nonprod_env ? 1 : 0
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = var.aadgroup_object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
}

# grant Pipeline service connection - DEVOPS-AZDO-DEV-Subscription-Contributor2
resource "azurerm_key_vault_access_policy" "kvpipelinesc" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = var.azdo_pipeline_contributor_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "sqlloginpswd" {
  name         = var.oneembark_sqlpswd
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kvembark.id
  depends_on   = [azurerm_key_vault_access_policy.kvpipelinesc]
}