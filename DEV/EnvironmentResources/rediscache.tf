# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redisembark" {
  name                = var.redis_cache_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_cache_capacity #SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4
  family              = var.redis_cache_family   #C (for Basic/Standard SKU family) and P (for Premium)
  sku_name            = var.redis_cache_sku      #Basic, Standard and Premium
  # enable_non_ssl_port = false    ## 'enable_non_ssl_port' will be removed in favour of the property 'non_ssl_port_enabled' in version 4.0 of the AzureRM Provider
  non_ssl_port_enabled          = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = var.redis_public_access

  redis_configuration {
    active_directory_authentication_enabled = true
  }

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

# resource "azurerm_private_endpoint" "redisembark-pe" {
# 	name	= var.redis_cache_privateendpoint_name
# 	location = var.location
# 	resource_group_name = var.resource_group_name
# 	subnet_id = var.private_endpoint_subnet_id
# 	tags	= {
#         "AppID" = var.AppID
#         "IAC"   = var.IACTag
#     }
#     lifecycle {
#         ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
#     }
# 	private_service_connection {
# 		name	= var.redis_cache_privateendpoint_name
# 		private_connection_resource_id = azurerm_redis_cache.redisembark.id
#     subresource_names = ["redisCache"]
# 		is_manual_connection = false
# 	}
# }

resource "azurerm_redis_cache_access_policy_assignment" "redis-access-policy-product-architects" {
  count              = var.nonprod_env ? 1 : 0
  name               = "WWC-WTW TR Ops SW PC Product Architects - Contributor"
  redis_cache_id     = azurerm_redis_cache.redisembark.id
  access_policy_name = "Data Contributor"
  object_id          = "df37ac84-dc7a-480d-8eb7-9cd6e2e4da5b"
  object_id_alias    = "WWC-WTW TR Ops SW PC Product Architects"
}

resource "azurerm_redis_firewall_rule" "k8s_public_ip" {
  name                = "k8s_public_ip"
  redis_cache_name    = azurerm_redis_cache.redisembark.name
  resource_group_name = azurerm_redis_cache.redisembark.resource_group_name
  start_ip            = var.k8s_public_ip
  end_ip              = var.k8s_public_ip
}

resource "azurerm_redis_firewall_rule" "k8s_failover_public_ip" {
  name                = "k8s_failover_public_ip"
  redis_cache_name    = azurerm_redis_cache.redisembark.name
  resource_group_name = azurerm_redis_cache.redisembark.resource_group_name
  start_ip            = var.k8s_failover_public_ip
  end_ip              = var.k8s_failover_public_ip
}