resource "azurerm_cdn_frontdoor_origin_group" "site-down" {
  cdn_frontdoor_profile_id                                  = var.afd_profile_id
  name                                                      = "site-down-group"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  load_balancing {
    additional_latency_in_milliseconds = 10
  }
}

data "azurerm_windows_web_app" "app_service" {
  name                = var.app_service_name
  resource_group_name = var.app_service_resource_group_name
}

resource "azurerm_cdn_frontdoor_origin" "site-down" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.site-down.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = data.azurerm_windows_web_app.app_service.default_hostname
  origin_host_header             = data.azurerm_windows_web_app.app_service.default_hostname
  name                           = "site-down-origin"
  weight                         = 50
  private_link {
    location               = var.dnn_region
    private_link_target_id = data.azurerm_windows_web_app.app_service.id
    request_message        = "AFD Site Down"
    target_type            = "sites"
  }
}
