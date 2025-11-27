resource "azurerm_cdn_profile" "cdn" {
  name                = "${local.regioncodeprefix}${var.env_code}cdn"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.cdn_sku

  tags = local.appx_tags
}

# PEX-3963 - [Engage] Custom Domain for B2C Assets Library
# PEX-4094 - Provision Azure CDN to Storage Accounts that are accessed from the Internet
resource "azurerm_cdn_endpoint" "projectexdnn" {
  name                = "${var.region_code}projectexdnn${var.env_code}stgsitecdn"
  profile_name        = azurerm_cdn_profile.cdn.name
  location            = var.location
  resource_group_name = var.resource_group_name
  origin_path         = "/assets"
  origin_host_header  = var.storage_projectexdnn_web_endpoint

  # PEX-7203 - Azure GR 371 - Azure CDN endpoints must not permit unencrypted (TCP 80) access
  
  is_http_allowed     = false

  # PEX-7677 - Enable CDN Compression

  is_compression_enabled = true
  content_types_to_compress = ["text/plain","text/html","text/css","text/javascript","application/x-javascript","application/javascript","application/json","application/xml"]

  # PEX-5643 - Security Scans: INVICTI: Security Scans: INVICTI: https://assets-embark-uat.ehr.com/ - Medium - HSTS policy is not enabled

  global_delivery_rule {
    modify_request_header_action {
      action = "Append"
      name   = local.header_name
      value  = local.header_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.header_name
      value  = local.header_value
    }
    modify_response_header_action {
      action = "Append"
      name   = local.referrer_name
      value  = local.referrer_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.content_name
      value  = local.content_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.frameoptions_name
      value  = local.frameoptions_value
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_defaults_assets
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_connect_assets
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_script_cdn_assets
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_script_cdn2_assets
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_style_assets
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_img_assets
    }

    modify_response_header_action {
      action = "Append"
      name   = local.cache_control_name
      value  = local.cache_control_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.permissions_name
      value  = local.permissions_value
    }
  }

  # PEX-6606 - Security Scans: INVICTI: http://assets-embark-uat.ehr.com/ - Medium - Insecure HTTP Usage
  delivery_rule {
    name  = "EnforceHTTPS"
    order = 1
    request_scheme_condition {
      match_values = [
        "HTTP",
      ]
      negate_condition = false
      operator         = "Equal"
    }
    url_redirect_action {
      protocol      = "Https"
      redirect_type = "Found"
    }
  }

  delivery_rule {
    name  = "CORSAuth" # Add CORS to Assets CDN - https://dev.azure.com/wtwdst/HRPortal/_workitems/edit/19148
    order = 2
    modify_response_header_action {
      action = "Delete"
      name   = "Access-Control-Allow-Origin"
    }
    modify_response_header_action {
      action = "Append"
      name   = "Access-Control-Allow-Origin"
      value  = "https://${local.commonauth_fqdn}"
    }
    request_header_condition {
      match_values     = [
        "https://${local.commonauth_fqdn}"
      ]  
      negate_condition = false
      operator         = "Equal"
      selector         = "Origin"
      transforms       = []
    }
  }

  delivery_rule {
    name  = "CORSEmbark" # Add CORS to Assets CDN - https://dev.azure.com/wtwdst/HRPortal/_workitems/edit/19148
    order = 3
    modify_response_header_action {
      action = "Delete"
      name   = "Access-Control-Allow-Origin"
    }
    modify_response_header_action {
      action = "Append"
      name   = "Access-Control-Allow-Origin"
      value  = "https://${local.rootconfigmicrofrontend_fqdn}"
    }
    request_header_condition {
      match_values     = [
        "https://${local.rootconfigmicrofrontend_fqdn}"
      ]  
      negate_condition = false
      operator         = "Equal"
      selector         = "Origin"
      transforms       = []
    }
  }

  origin {
    name      = "${local.regioncodeprefix}projectexdnn${var.env_code}stgsitecdn"
    host_name = var.storage_projectexdnn_web_endpoint
  }

  tags = local.appx_tags
}

# PEX-3963 - [Engage] Custom Domain for B2C Assets Library
# PEX-4094 - Provision Azure CDN to Storage Accounts that are accessed from the Internet
resource "azurerm_cdn_endpoint_custom_domain" "projectexdnn" {
  name            = "projectexdnn-embark"
  cdn_endpoint_id = azurerm_cdn_endpoint.projectexdnn.id
  host_name       = local.assets_cdn_fqdn
  lifecycle {
    ignore_changes = [
      user_managed_https
    ]
  }
}

# PEX-4141 - [DevOps] Create CDN storage account for Micro Frontend
resource "azurerm_cdn_endpoint" "microfrontend" {
  name                = "${var.region_code}microfrontend${var.env_code}stgsitecdn"
  profile_name        = azurerm_cdn_profile.cdn.name
  location            = var.location
  resource_group_name = var.resource_group_name
  origin_path         = "/pex-microfrontend"
  origin_host_header  = var.storage_projectexdnn_web_endpoint

  # PEX-7203 - Azure GR 371 - Azure CDN endpoints must not permit unencrypted (TCP 80) access

  is_http_allowed     = false
  
  # PEX-7677 - Enable CDN Compression

  is_compression_enabled = true
  content_types_to_compress = ["text/plain","text/html","text/css","text/javascript","application/x-javascript","application/javascript","application/json","application/xml"]

  # PEX-5645 - Security Scans: INVICTI: https://microfrontend-embark-uat.ehr.com/ - Medium - HSTS policy is not enabled

  global_delivery_rule {
    modify_request_header_action {
      action = "Append"
      name   = local.header_name
      value  = local.header_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.header_name
      value  = local.header_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.referrer_name
      value  = local.referrer_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.content_name
      value  = local.content_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.frameoptions_name
      value  = local.frameoptions_value
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_defaults
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_connect
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_script_cdn
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_script_cdn2
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_style
    }

    modify_response_header_action {
      action = "Append"
      name   = "Content-Security-Policy"
      value  = local.csp_rootconfig_img
    }

    modify_response_header_action {
      action = "Append"
      name   = local.cache_control_name
      value  = local.cache_control_value
    }

    modify_response_header_action {
      action = "Append"
      name   = local.permissions_name
      value  = local.permissions_value
    }
  }

  # PEX-6607 - Security Scans: INVICTI: http://microfrontend-embark-uat.ehr.com/ - Medium - Insecure HTTP Usage
  delivery_rule {
    name  = "EnforceHTTPS"
    order = 1
    request_scheme_condition {
      match_values = [
        "HTTP",
      ]
      negate_condition = false
      operator         = "Equal"
    }
    url_redirect_action {
      protocol      = "Https"
      redirect_type = "Found"
    }
  }

  delivery_rule {
    name  = "CORSEmbark" # Add CORS to Microfronend CDN - https://dev.azure.com/wtwdst/HRPortal/_workitems/edit/19148
    order = 2
    modify_response_header_action {
      action = "Delete"
      name   = "Access-Control-Allow-Origin"
    }
    modify_response_header_action {
      action = "Append"
      name   = "Access-Control-Allow-Origin"
      value  = "https://${local.rootconfigmicrofrontend_fqdn}"
    }
    request_header_condition {
      match_values     = [
        "https://${local.rootconfigmicrofrontend_fqdn}"
      ]  
      negate_condition = false
      operator         = "Contains"
      selector         = "Origin"
      transforms       = []  
    }
  }

  delivery_rule {
    name  = "CORSClientAdmin" # Add CORS to Microfronend CDN - https://dev.azure.com/wtwdst/HRPortal/_workitems/edit/19148
    order = 3
    modify_response_header_action {
      action = "Delete"
      name   = "Access-Control-Allow-Origin"
    }
    modify_response_header_action {
      action = "Append"
      name   = "Access-Control-Allow-Origin"
      value  = "https://${local.cltadmin_fqdn}"
    }
    request_header_condition {
      match_values     = [
        "https://${local.cltadmin_fqdn}"
      ]  
      negate_condition = false
      operator         = "Contains"
      selector         = "Origin"
      transforms       = []  
    }
  }

  origin {
    name      = "${local.regioncodeprefix}microfrontend${var.env_code}stgsitecdn"
    host_name = var.storage_projectexdnn_web_endpoint
  }

  tags = local.appx_tags
}

# # PEX-4141 - [DevOps] Create CDN storage account for Micro Frontend
resource "azurerm_cdn_endpoint_custom_domain" "microfrontend" {
  name            = "microfrontend-embark"
  cdn_endpoint_id = azurerm_cdn_endpoint.microfrontend.id
  host_name       = local.microfrontend_cdn_fqdn
  lifecycle {
    ignore_changes = [
      user_managed_https
    ]
  }
}
