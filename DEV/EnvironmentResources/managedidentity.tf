resource "azurerm_user_assigned_identity" "oneembark" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "${var.regionCode}${var.appname}${var.envCode}oneembarkmicroserviceidentity"

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_federated_identity_credential" "oneembark-fic" {
  name                = "oneembark-fic"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_url
  parent_id           = azurerm_user_assigned_identity.oneembark.id
  subject             = "system:serviceaccount:${var.namespace}:oneembarkmicroserviceidentity-sa"
}

resource "azurerm_federated_identity_credential" "oneembark-ficdr" {
  name                = "oneembark-ficdr"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.issuer_failover_url
  parent_id           = azurerm_user_assigned_identity.oneembark.id
  subject             = "system:serviceaccount:${var.namespace}:oneembarkmicroserviceidentity-sa"
}

# Grant OneEmbark Permission to KeyVault
resource "azurerm_key_vault_access_policy" "kvoneembarkmi" {
  key_vault_id = azurerm_key_vault.kvembark.id
  tenant_id    = "76e3921f-489b-4b7e-9547-9ea297add9b5"
  object_id    = azurerm_user_assigned_identity.oneembark.principal_id

  secret_permissions = [
    "Get", "List"
  ]
}

# Grant OneEmbark Permission to AppConfig
resource "azurerm_role_assignment" "oneembark-config-reader-assignment" {
  scope                = azurerm_app_configuration.appconfembark.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_user_assigned_identity.oneembark.principal_id
}

# Grant OneEmbark Permission to Service Bus
resource "azurerm_role_assignment" "oneembark-owner-assignment" {
  scope                = azurerm_servicebus_namespace.asbembark.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_user_assigned_identity.oneembark.principal_id
}

# Grant OneEmbark Permission to Redis
resource "azurerm_redis_cache_access_policy_assignment" "oneembark-redis-access-policy" {
  name               = azurerm_user_assigned_identity.oneembark.name
  redis_cache_id     = azurerm_redis_cache.redisembark.id
  access_policy_name = "Data Owner"
  object_id          = azurerm_user_assigned_identity.oneembark.principal_id
  object_id_alias    = azurerm_user_assigned_identity.oneembark.name
}

output "oneembark_identity_resource_clientId" {
  value = azurerm_user_assigned_identity.oneembark.client_id
}