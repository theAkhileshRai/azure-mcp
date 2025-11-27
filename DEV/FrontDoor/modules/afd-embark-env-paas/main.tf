resource "azurerm_cdn_frontdoor_secret" "experience-devint-certificate" {
  cdn_frontdoor_profile_id = var.afd_profile_id
  name                     = replace(var.host_name, ".", "-")
  secret {
    customer_certificate {
      key_vault_certificate_id = "https://${var.keyvault_name}.vault.azure.net/certificates/${replace(var.host_name, ".", "-")}"
    }
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "domain" {
  cdn_frontdoor_profile_id = var.afd_profile_id
  host_name                = var.host_name
  name                     = replace(var.host_name, ".", "-")
  tls {
    certificate_type        = "CustomerCertificate"
    cdn_frontdoor_secret_id = azurerm_cdn_frontdoor_secret.experience-devint-certificate.id
  }
}

resource "azurerm_cdn_frontdoor_secret" "experience-kb-devint-certificate" {
  cdn_frontdoor_profile_id = var.afd_profile_id
  name                     = replace(var.kb_host_name, ".", "-")
  secret {
    customer_certificate {
      key_vault_certificate_id = "https://${var.keyvault_name}.vault.azure.net/certificates/${replace(var.kb_host_name, ".", "-")}"
    }
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "kb-domain" {
  cdn_frontdoor_profile_id = var.afd_profile_id
  host_name                = var.kb_host_name
  name                     = replace(var.kb_host_name, ".", "-")
  tls {
    certificate_type        = "CustomerCertificate"
    cdn_frontdoor_secret_id = azurerm_cdn_frontdoor_secret.experience-kb-devint-certificate.id
  }
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  cdn_frontdoor_profile_id = var.afd_profile_id
  name                     = replace(var.host_name, ".", "-")
  tags                     = merge({}, var.default_tags)
  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"]]
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "mfe" {
  cdn_frontdoor_profile_id                                  = var.afd_profile_id
  name                                                      = "MFE-${var.env_name}"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  # health_probe {
  #   interval_in_seconds = 60
  #   path                = "/embarkmfe/ess-host-9x/index.html"
  #   protocol            = "Https"
  #   request_type        = "HEAD"
  # }

  # load_balancing {
  #   additional_latency_in_milliseconds = 50
  #   sample_size                        = 4
  #   successful_samples_required        = 3
  # }
  load_balancing {
  }
}

resource "azurerm_cdn_frontdoor_origin" "mfe" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.mfe.id
  certificate_name_check_enabled = true
  enabled                        = var.enable_primary_region
  host_name                      = var.host_name
  priority                       = 1
  name                           = "MFE-${var.env_name}"
  weight                         = 50
  private_link {
    location               = var.k8s_region
    private_link_target_id = var.k8s_private_link_id
    request_message        = "Embark Pro Environment: ${var.env_name}"
  }
}

resource "azurerm_cdn_frontdoor_origin" "mfe2" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.mfe.id
  certificate_name_check_enabled = true
  enabled                        = var.enable_dr_region
  host_name                      = var.host_name
  priority                       = 2
  name                           = "MFE-${var.env_name}-dr"
  weight                         = 50
  private_link {
    location               = var.k8s_dr_region
    private_link_target_id = var.k8s_dr_private_link_id
    request_message        = "Embark Pro Environment: ${var.env_name}"
  }
}


resource "azurerm_cdn_frontdoor_origin_group" "api" {
  cdn_frontdoor_profile_id                                  = var.afd_profile_id
  name                                                      = "API-${var.env_name}"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  # health_probe {
  #   interval_in_seconds = 60
  #   path                = "/embarkmfe/ess-host-9x/index.html"
  #   protocol            = "Https"
  #   request_type        = "HEAD"
  # }

  # load_balancing {
  #   additional_latency_in_milliseconds = 50
  #   sample_size                        = 4
  #   successful_samples_required        = 3
  # }
  load_balancing {
  }
}

resource "azurerm_cdn_frontdoor_origin" "api" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.api.id
  certificate_name_check_enabled = true
  enabled                        = var.enable_primary_region
  host_name                      = var.host_name
  priority                       = 1
  name                           = "API-${var.env_name}"
  weight                         = 50
  private_link {
    location               = var.k8s_region
    private_link_target_id = var.k8s_private_link_id
    request_message        = "Embark Pro Environment: ${var.env_name}"
  }
}

# resource "azurerm_cdn_frontdoor_origin" "api2" {
#   cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.api.id
#   certificate_name_check_enabled = true
#   enabled                        = var.enable_dr_region
#   host_name                      = var.host_name
#   priority                       = 2
#   name                           = "API-${var.env_name}-dr"
#   weight                         = 100
#   private_link {
#     location               = var.k8s_region
#     private_link_target_id = var.k8s_private_link_id
#     request_message        = "Embark Pro Environment: ${var.env_name}"
#   }
# }

resource "azurerm_cdn_frontdoor_origin_group" "dnn" {
  cdn_frontdoor_profile_id                                  = var.afd_profile_id
  name                                                      = "DNN-${var.env_name}"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  load_balancing {
    additional_latency_in_milliseconds = 10
  }
}

data "azurerm_windows_web_app" "hrportal_app_service" {
  name                = var.app_service_name
  resource_group_name = var.app_service_resource_group_name
}

resource "azurerm_cdn_frontdoor_origin" "dnn" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.dnn.id
  certificate_name_check_enabled = true
  enabled                        = var.enable_paas_region
  host_name                      = data.azurerm_windows_web_app.hrportal_app_service.default_hostname
  name                           = "DNN-${var.env_name}"
  weight                         = 50
  private_link {
    location               = var.dnn_region
    private_link_target_id = data.azurerm_windows_web_app.hrportal_app_service.id
    request_message        = "Embark Pro Environment: ${var.env_name}"
    target_type            = "sites"
  }
}

data "azurerm_windows_web_app" "hrportal_app_service2" {
  count               = var.include_paas_dr_region ? 1 : 0
  name                = var.app_service_dr_name
  resource_group_name = var.app_service_dr_resource_group_name
}

resource "azurerm_cdn_frontdoor_origin" "dnn2" {
  count                          = var.include_paas_dr_region ? 1 : 0
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.dnn.id
  certificate_name_check_enabled = true
  enabled                        = var.enable_paas_dr_region
  host_name                      = data.azurerm_windows_web_app.hrportal_app_service2[0].default_hostname
  name                           = "DNN-${var.env_name}-dr"
  weight                         = 50
  private_link {
    location               = data.azurerm_windows_web_app.hrportal_app_service2[0].location
    private_link_target_id = data.azurerm_windows_web_app.hrportal_app_service2[0].id
    request_message        = "Embark Pro Environment: ${var.env_name}-dr"
    target_type            = "sites"
  }
}

resource "azurerm_cdn_frontdoor_route" "mfe" {
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.domain.id, azurerm_cdn_frontdoor_custom_domain.kb-domain.id]
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.mfe.id]
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.mfe.id
  cdn_frontdoor_rule_set_ids      = [azurerm_cdn_frontdoor_rule_set.ruleset.id]
  cdn_frontdoor_origin_path       = "/embarkmfe/"
  forwarding_protocol             = "HttpsOnly"
  link_to_default_domain          = false
  name                            = "MFE-${var.env_name}"
  patterns_to_match               = ["/embarkmfe/*"]
  supported_protocols             = ["Http", "Https"]
  cache {
    compression_enabled           = true
    content_types_to_compress     = ["application/eot", "application/font", "application/font-sfnt", "application/javascript", "application/opentype", "application/otf", "application/pkcs7-mime", "application/truetype", "application/ttf", "application/vnd.ms-fontobject", "application/xml", "application/xml+rss", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "application/x-httpd-cgi", "application/x-javascript", "application/x-mpegurl", "application/x-opentype", "application/x-otf", "application/x-perl", "application/x-ttf", "font/eot", "font/ttf", "font/otf", "font/opentype", "image/svg+xml", "text/css", "text/csv", "text/javascript", "text/js", "text/plain", "text/richtext", "text/tab-separated-values", "text/xml", "text/x-script", "text/x-component", "text/x-java-source"]
    query_string_caching_behavior = "UseQueryString"
  }
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.endpoint,
    azurerm_cdn_frontdoor_custom_domain.domain,
    azurerm_cdn_frontdoor_custom_domain.kb-domain,
    azurerm_cdn_frontdoor_origin_group.mfe,
  ]
}

resource "azurerm_cdn_frontdoor_route" "api" {
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.domain.id, azurerm_cdn_frontdoor_custom_domain.kb-domain.id]
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.api.id]
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.api.id
  cdn_frontdoor_rule_set_ids      = [azurerm_cdn_frontdoor_rule_set.ruleset.id]
  cdn_frontdoor_origin_path       = "/embarkapi/"
  forwarding_protocol             = "HttpsOnly"
  link_to_default_domain          = false
  name                            = "API-${var.env_name}"
  patterns_to_match               = ["/embarkapi/*"]
  supported_protocols             = ["Http", "Https"]
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.endpoint,
    azurerm_cdn_frontdoor_custom_domain.domain,
    azurerm_cdn_frontdoor_custom_domain.kb-domain,
    azurerm_cdn_frontdoor_origin_group.api,
  ]
}

resource "azurerm_cdn_frontdoor_route" "dnn" {
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.domain.id, azurerm_cdn_frontdoor_custom_domain.kb-domain.id]
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.dnn.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.dnn.id]
  cdn_frontdoor_rule_set_ids      = [azurerm_cdn_frontdoor_rule_set.ruleset.id]
  forwarding_protocol             = "HttpsOnly"
  link_to_default_domain          = false
  name                            = "DNN-${var.env_name}"
  patterns_to_match               = ["/*"]
  supported_protocols             = ["Http", "Https"]
  cache {
    compression_enabled           = true
    content_types_to_compress     = ["application/eot", "application/font", "application/font-sfnt", "application/javascript", "application/opentype", "application/otf", "application/pkcs7-mime", "application/truetype", "application/ttf", "application/vnd.ms-fontobject", "application/xml", "application/xml+rss", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "application/x-httpd-cgi", "application/x-javascript", "application/x-mpegurl", "application/x-opentype", "application/x-otf", "application/x-perl", "application/x-ttf", "font/eot", "font/ttf", "font/otf", "font/opentype", "image/svg+xml", "text/css", "text/csv", "text/javascript", "text/js", "text/plain", "text/richtext", "text/tab-separated-values", "text/xml", "text/x-script", "text/x-component", "text/x-java-source"]
    query_string_caching_behavior = "UseQueryString"
  }
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.endpoint,
    azurerm_cdn_frontdoor_custom_domain.domain,
    azurerm_cdn_frontdoor_custom_domain.kb-domain,
    azurerm_cdn_frontdoor_origin_group.dnn,
  ]
}

resource "azurerm_cdn_frontdoor_origin_group" "cdn" {
  cdn_frontdoor_profile_id                                  = var.afd_profile_id
  name                                                      = "CDN-${var.env_name}"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false

  load_balancing {
  }
}

resource "azurerm_cdn_frontdoor_origin" "cdn" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.cdn.id
  certificate_name_check_enabled = true
  enabled                        = true
  host_name                      = var.cdn_host_name
  origin_host_header             = var.cdn_host_name
  priority                       = 1
  name                           = "CDN-${var.env_name}"
  weight                         = 10
}

resource "azurerm_cdn_frontdoor_route" "cdn" {
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.domain.id, azurerm_cdn_frontdoor_custom_domain.kb-domain.id]
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.cdn.id]
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.cdn.id
  cdn_frontdoor_rule_set_ids      = [azurerm_cdn_frontdoor_rule_set.ruleset.id]
  cdn_frontdoor_origin_path       = ""
  forwarding_protocol             = "HttpsOnly"
  link_to_default_domain          = false
  name                            = "CDN-${var.env_name}"
  patterns_to_match               = ["/desktopmodules/hrportal/portalcore/ascripts/*", "/svc/clientdatafactory/*", "/svc/intcat/*"]
  supported_protocols             = ["Http", "Https"]
  cache {
    compression_enabled           = true
    content_types_to_compress     = ["application/eot", "application/font", "application/font-sfnt", "application/javascript", "application/opentype", "application/otf", "application/pkcs7-mime", "application/truetype", "application/ttf", "application/vnd.ms-fontobject", "application/xml", "application/xml+rss", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "application/x-httpd-cgi", "application/x-javascript", "application/x-mpegurl", "application/x-opentype", "application/x-otf", "application/x-perl", "application/x-ttf", "font/eot", "font/ttf", "font/otf", "font/opentype", "image/svg+xml", "text/css", "text/csv", "text/javascript", "text/js", "text/plain", "text/richtext", "text/tab-separated-values", "text/xml", "text/x-script", "text/x-component", "text/x-java-source"]
    query_string_caching_behavior = "UseQueryString"
  }
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.endpoint,
    azurerm_cdn_frontdoor_custom_domain.domain,
    azurerm_cdn_frontdoor_custom_domain.kb-domain,
    azurerm_cdn_frontdoor_origin_group.cdn,
  ]
}

resource "azurerm_cdn_frontdoor_rule_set" "ruleset" {
  name                     = "${replace(var.env_name, "-", "")}ServerHeaderRuleSet"
  cdn_frontdoor_profile_id = var.afd_profile_id
}

resource "azurerm_cdn_frontdoor_rule" "deleterule" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.dnn,
    azurerm_cdn_frontdoor_origin.dnn,
    azurerm_cdn_frontdoor_origin_group.api,
    azurerm_cdn_frontdoor_origin.api,
    azurerm_cdn_frontdoor_origin_group.mfe,
    azurerm_cdn_frontdoor_origin.mfe
  ]

  name                      = "${replace(var.env_name, "-", "")}DeleteServerHeaders"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.ruleset.id
  order                     = 0
  behavior_on_match         = "Continue"

  actions {
    response_header_action {
      header_action = "Delete"
      header_name   = "Server"
    }

    response_header_action {
      header_action = "Delete"
      header_name   = "X-Powered-By"
    }

    response_header_action {
      header_action = "Delete"
      header_name   = "X-AspNet-Version"
    }
  }
}

resource "azurerm_cdn_frontdoor_rule" "addrule" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.dnn,
    azurerm_cdn_frontdoor_origin.dnn,
    azurerm_cdn_frontdoor_origin_group.api,
    azurerm_cdn_frontdoor_origin.api,
    azurerm_cdn_frontdoor_origin_group.mfe,
    azurerm_cdn_frontdoor_origin.mfe
  ]

  name                      = "${replace(var.env_name, "-", "")}AddSecurityHeaders"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.ruleset.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    response_header_action {
      header_action = "Overwrite"
      header_name   = "Strict-Transport-Security"
      value         = "max-age=63072000; includeSubDomains; preload"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "X-Content-Type-Options"
      value         = "nosniff"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "Referrer-Policy"
      value         = "strict-origin-when-cross-origin"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "X-Frame-Options"
      value         = "SAMEORIGIN"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "X-Permitted-Cross-Domain-Policies"
      value         = "none"
    }
  }
}
