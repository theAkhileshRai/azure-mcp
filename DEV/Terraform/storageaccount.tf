# https://www.terraform.io/docs/providers/azurerm/r/storage_account.html
resource "azurerm_storage_account" "documentlibrary" {
  name                     = "${local.regioncodeprefix}doclib${var.env_code}stg"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication_type # one of LRS, GRS, RAGRS ; see https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy
  lifecycle {
    prevent_destroy = true
  }
  # Enable soft delete retention
  blob_properties {
    delete_retention_policy {
      days = 30 # 7 is default
    }
  }

  # PEX-5153 - Azure GuardRails 290 - Storage accounts must have the specified minimum TLS version
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  /* # holding off on these for now. Only allow WTW and Document Storage App SVC
  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"] # see: https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security#exceptions
    ip_rules = ["32.66.102.170","32.66.102.171","32.66.102.172","32.66.102.173","32.66.102.174","32.66.114.161","32.66.114.162",   "32.66.114.163","32.66.114.164","32.66.114.165","32.65.74.146","32.65.74.147","32.65.74.148","32.65.74.149","32.65.74.150","158.82.143.130","158.82.159.130","202.167.233.229","27.111.213.117","41.242.168.121","52.254.79.207","52.247.126.178","52.168.82.81","52.177.0.71","52.177.116.166","89.28.187.5","89.28.187.6","89.28.187.7","89.28.187.8","89.28.187.9","89.28.187.10","89.28.187.11","89.28.187.12","158.82.143.120","158.82.159.120"]
  }
*/
  tags = local.appx_tags
}

resource "azurerm_storage_account" "assets" {
  name                     = "${local.regioncodeprefix}assets${var.env_code}stg"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication_type # one of LRS, GRS, RAGRS ; see https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy
  lifecycle {
    prevent_destroy = true
  }
  # Enable soft delete retention
  blob_properties {
    delete_retention_policy {
      days = 30 # 7 is default
    }
    # cors:  http://jira.ehr.com/browse/DEVOPS-12785
    # https://docs.microsoft.com/en-us/rest/api/storageservices/Cross-Origin-Resource-Sharing--CORS--Support-for-the-Azure-Storage-Services
    cors_rule {
      allowed_origins = local.assets_cors
      allowed_methods = ["GET", "OPTIONS"]
      allowed_headers = ["*"]
      exposed_headers = ["*"]
      # blob_properties.0.cors_rule.0.max_age_in_seconds to be in the range (1 - 2000000000)
      # settings: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Max-Age
      max_age_in_seconds = 10
    }
  }

  # PEX-5153 - Azure GuardRails 290 - Storage accounts must have the specified minimum TLS version
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  allow_blob_public_access = false # GR 394 - Blob storage accounts must be configured to not allow anonymous access

  # allow_blob_public_access = true #, required for b2c
  /* # holding off on these for now. Only allow WTW and Document Storage App SVC
  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"] # see: https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security#exceptions
    ip_rules = ["32.66.102.170","32.66.102.171","32.66.102.172","32.66.102.173","32.66.102.174","32.66.114.161","32.66.114.162",   "32.66.114.163","32.66.114.164","32.66.114.165","32.65.74.146","32.65.74.147","32.65.74.148","32.65.74.149","32.65.74.150","158.82.143.130","158.82.159.130","202.167.233.229","27.111.213.117","41.242.168.121","52.254.79.207","52.247.126.178","52.168.82.81","52.177.0.71","52.177.116.166","89.28.187.5","89.28.187.6","89.28.187.7","89.28.187.8","89.28.187.9","89.28.187.10","89.28.187.11","89.28.187.12","158.82.143.120","158.82.159.120"]
  }
*/
  tags = local.appx_tags
}
