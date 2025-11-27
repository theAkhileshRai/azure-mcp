resource "azurerm_cdn_frontdoor_secret" "embarkstandard-certificate" {
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
    cdn_frontdoor_secret_id = azurerm_cdn_frontdoor_secret.embarkstandard-certificate.id
  }
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  cdn_frontdoor_profile_id  = var.afd_profile_id
  name                      = replace(var.host_name, ".", "-")
  tags                      = merge({}, var.default_tags)
  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"]]
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "std" {
  cdn_frontdoor_profile_id                                  = var.afd_profile_id
  name                                                      = "STD-${var.env_name}"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false

  # Only use Health Probes if you have two or more origins in the group
  # health_probe {
  #   interval_in_seconds = 60
  #   path                = "/probe"
  #   protocol            = "Https"
  #   request_type        = "GET"
  # }

  load_balancing {
    additional_latency_in_milliseconds  = 50
    sample_size                         = 4
    successful_samples_required         = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "std" {
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.std.id
  certificate_name_check_enabled  = true
  enabled                         = var.enable_primary_region
  host_name                       = var.host_name
  priority                        = 1
  name                            = "STD-${var.env_name}"
  weight                          = 100
  private_link {
    location                      = var.k8s_region
    private_link_target_id        = var.k8s_private_link_id
    request_message               = "Embark Pro Environment: ${var.env_name}"
  }
}

resource "azurerm_cdn_frontdoor_origin" "std-dr" {
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.std.id
  certificate_name_check_enabled  = true
  enabled                         = var.enable_dr_region
  host_name                       = var.host_name
  priority                        = 1
  name                            = "STD-${var.env_name}-dr"
  weight                          = 100
  private_link {
    location                      = var.k8s_dr_region
    private_link_target_id        = var.k8s_dr_private_link_id
    request_message               = "Embark Pro Environment: ${var.env_name}"
  }
}

resource "azurerm_cdn_frontdoor_route" "std" {
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.domain.id]
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.std.id]
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.std.id
  cdn_frontdoor_rule_set_ids      = [azurerm_cdn_frontdoor_rule_set.ruleset.id]
  cdn_frontdoor_origin_path       = "/"
  forwarding_protocol             = "HttpsOnly"
  link_to_default_domain          = false
  name                            = "STD-${var.env_name}"
  patterns_to_match               = ["/*"]
  supported_protocols             = ["Http", "Https"]
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "text/css", "text/javascript", "text/xml", "application/javascript"]
  }
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.endpoint,
    azurerm_cdn_frontdoor_custom_domain.domain,
    azurerm_cdn_frontdoor_origin_group.std,
  ]
}

resource "azurerm_cdn_frontdoor_rule_set" "ruleset" {
  name                     = "std${var.env_name}ServerHeaderRuleSet"
  cdn_frontdoor_profile_id = var.afd_profile_id
}

resource "azurerm_cdn_frontdoor_rule" "deleterule" {
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.std,
    azurerm_cdn_frontdoor_origin.std
  ]

  name                      = "std${var.env_name}DeleteServerHeaders"
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
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.std,
    azurerm_cdn_frontdoor_origin.std
  ]
  
  name                      = "std${var.env_name}AddSecurityHeaders"
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
  }
}

resource "azurerm_cdn_frontdoor_rule" "addrule2" {
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.std,
    azurerm_cdn_frontdoor_origin.std
  ]
  
  name                      = "std${var.env_name}AddSecurityHeaders2"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.ruleset.id
  order                     = 2
  behavior_on_match         = "Continue"

  actions {
    response_header_action {
      header_action = "Overwrite"
      header_name   = "Cache-Control"
      value         = "no-cache"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "Permissions-Policy"
      value         = var.permissions_policy_value
    }
  }
}

resource "azurerm_cdn_frontdoor_rule" "addcsprule" {
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.std,
    azurerm_cdn_frontdoor_origin.std
  ]
  
  name                      = "std${var.env_name}AddCSPHeaders"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.ruleset.id
  order                     = 3
  behavior_on_match         = "Continue"

  actions {
    response_header_action {
      header_action = "Overwrite"
      header_name   = "Content-Security-Policy"
      value         = "default-src 'self' https://*.content-cms.com/ ${var.csp_header_localhost}; form-action 'self' https:; base-uri 'self' https://*.ehr.com/ ${var.csp_header_assetsblob_microfrontendcdn}; frame-src 'self' https: https://www.recaptcha.net/ ${var.csp_header_localhost}; frame-ancestors 'self' https://*.ehr.com/; object-src 'self';"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "Content-Security-Policy"
      value         = "connect-src 'self' blob: ${var.csp_header_localhost} wss://${var.csp_header_embarkstd_domain}:*/ wss://*.intercom.io/ https://dc.services.visualstudio.com/v2/track https://cdn.cookielaw.org/ https://geolocation.onetrust.com/ https://*.onetrust.com/ https://*.ehr.com https://*.willistowerswatson.com  https://*.azurewebsites.net/ https://*.content-cms.com/ ${var.csp_header_assetsblob_microfrontendcdn} https://js.monitor.azure.com/ https://*.intercom.io/;"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "Content-Security-Policy"
      value         = "script-src 'self' ${var.csp_header_localhost} https://*.ehr.com/ ${var.csp_header_assetsblob_microfrontendcdn} https://*.azurewebsites.net/ https://cdn.jsdelivr.net/npm/ https://ajax.googleapis.com/ajax/libs/ https://cdn.cookielaw.org/ https://gstatic.com/ https://fonts.googleapis.com/ https://*.onetrust.com/ https://code.jquery.com/ https://*.content-cms.com/ https://ajax.aspnetcdn.com/ https://*.ehr.com/;" # removed unsafe-inline as part of Pentest item 14821
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "Content-Security-Policy"
      value         = "script-src https://www.sc.pages01.net/ https://www.sc.pages02.net/ https://www.sc.pages03.net/ https://www.sc.pages04.net/ https://www.sc.pages05.net/ https://www.sc.pages06.net/ https://www.sc.pages07.net/ https://www.sc.pages08.net/ https://www.sc.pages09.net/ https://www.sc.pagesA.net/;"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "Content-Security-Policy"
      value         = "style-src 'self' https://*.ehr.com/ ${var.csp_header_microfrontendcdn} ${var.csp_header_assetsblob} ${var.csp_header_microfrontendcdn_domain} ${var.csp_header_assetscdn_domain} https://fonts.googleapis.com/ https://www.pages06.net/ https://*.onetrust.com/ https://ajax.aspnetcdn.com/; font-src 'self' https://*.ehr.com/ https://fonts.gstatic.com/ https://*.onetrust.com/ https://*.content-cms.com/ ${var.csp_header_microfrontendcdn} https://fonts.intercomcdn.com/;" # removed unsafe-inline as part of Pentest item 14821
    }
  }
}

resource "azurerm_cdn_frontdoor_rule" "addcsprule2" {
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.std,
    azurerm_cdn_frontdoor_origin.std
  ]
  
  name                      = "std${var.env_name}AddCSPHeaders2"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.ruleset.id
  order                     = 4
  behavior_on_match         = "Continue"

  actions {
    response_header_action {
      header_action = "Overwrite"
      header_name   = "Content-Security-Policy"
      value         = "img-src data: blob: https:;"
    }
  }
}