resource "azurerm_app_configuration" "appconfembark" {
  name                  = var.appconfigname
  location              = var.location
  resource_group_name   = var.resource_group_name
  sku                   = "standard"
  public_network_access = var.public_access
  local_auth_enabled    = var.appconfig_local_auth_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }

  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

## Role assigments to App config
resource "azurerm_role_assignment" "devteam-reader-assignment" {
  scope                = azurerm_app_configuration.appconfembark.id
  role_definition_name = var.envCode == "devint" ? "App Configuration Data Owner" : "App Configuration Data Reader"
  principal_id         = var.aadgroup_object_id
}

resource "azurerm_private_endpoint" "embarkappconfig-pe" {
  name                = var.appcfg_privateendpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags = {
    "AppID" = var.AppID
    "IAC"   = var.IACTag
  }
  lifecycle {
    ignore_changes = [tags["billingbusiness"], tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
  private_service_connection {
    name                           = var.appcfg_privateendpoint_name
    private_connection_resource_id = azurerm_app_configuration.appconfembark.id
    subresource_names              = ["configurationStores"]
    is_manual_connection           = false
  }
}