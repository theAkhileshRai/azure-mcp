resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}
resource "azurerm_log_analytics_workspace" "law" {
  name                = local.log_analytics_name
  location            = local.location
  resource_group_name = azurerm_resource_group.resource-group.name
  sku                 = "PerGB2018"
  retention_in_days   = 60

  tags = merge({}, var.default_tags)
  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"]]
  }
}

resource "azurerm_monitor_diagnostic_setting" "agwdiag" {
  name                            = "agwdiag"
  target_resource_id              = azurerm_cdn_frontdoor_profile.profile.id
  log_analytics_workspace_id      = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "FrontDoorAccessLog"
  }

  enabled_log {
    category = "FrontDoorHealthProbeLog"
  }

  enabled_log {
    category = "FrontDoorWebApplicationFirewallLog"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}