terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.embarkdns]
    }
  }
}

//This is the primary host name for the site
resource "azurerm_cdn_frontdoor_secret" "certificate" {
  cdn_frontdoor_profile_id = var.afd_profile_id
  name                     = replace(var.primary_host_name, ".", "-")
  secret {
    customer_certificate {
      key_vault_certificate_id = "https://${var.keyvault_name}.vault.azure.net/certificates/${replace(var.primary_host_name, ".", "-")}"
    }
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "domain" {
  cdn_frontdoor_profile_id = var.afd_profile_id
  host_name                = var.primary_host_name
  name                     = replace(var.primary_host_name, ".", "-")
  tls {
    certificate_type        = "CustomerCertificate"
    cdn_frontdoor_secret_id = azurerm_cdn_frontdoor_secret.certificate.id
  }
}
//End

//These are the vanity domains the site will be accessed by
resource "azurerm_cdn_frontdoor_secret" "certificates" {
  for_each                 = toset(var.host_names)
  cdn_frontdoor_profile_id = var.afd_profile_id
  name                     = replace(each.key, ".", "-")
  secret {
    customer_certificate {
      key_vault_certificate_id = "https://${var.keyvault_name}.vault.azure.net/certificates/${replace(each.key, ".", "-")}"
    }
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "domains" {
  for_each                 = azurerm_cdn_frontdoor_secret.certificates
  cdn_frontdoor_profile_id = var.afd_profile_id
  host_name                = replace(each.value, "-", ".")
  name                     = each.value
  tls {
    certificate_type        = "CustomerCertificate"
    cdn_frontdoor_secret_id = each.value.id
  }
}
//End

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  cdn_frontdoor_profile_id = var.afd_profile_id
  name                     = replace(var.primary_host_name, ".", "-")
  tags                     = merge({}, var.default_tags)
  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"]]
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "one" {
  cdn_frontdoor_profile_id                                  = var.afd_profile_id
  name                                                      = "one-embark-${var.env_name}"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false

  # Commenting out until we want to use load balancing or DR
  # health_probe {
  #   interval_in_seconds = 60
  #   path                = "/"
  #   protocol            = "Https"
  #   request_type        = "GET"
  # }

  # load_balancing {
  #   additional_latency_in_milliseconds = 50
  #   sample_size                        = 4
  #   successful_samples_required        = 3
  # }
  load_balancing {
  }
}

resource "azurerm_cdn_frontdoor_origin" "one" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.one.id
  certificate_name_check_enabled = true
  enabled                        = var.enable_primary_region
  host_name                      = var.primary_host_name
  priority                       = 1
  name                           = "one-embark-${var.env_name}"
  weight                         = 100
  private_link {
    location               = var.k8s_region
    private_link_target_id = var.k8s_private_link_id
    request_message        = "Embark Pro Environment: ${var.env_name}"
  }
}

resource "azurerm_cdn_frontdoor_origin" "one-dr" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.one.id
  certificate_name_check_enabled = true
  enabled                        = var.enable_dr_region
  host_name                      = var.primary_host_name
  priority                       = 1
  name                           = "one-embark-${var.env_name}-dr"
  weight                         = 100
  private_link {
    location               = var.k8s_dr_region
    private_link_target_id = var.k8s_dr_private_link_id
    request_message        = "Embark Pro DR Environment: ${var.env_name}"
  }
}

resource "azurerm_cdn_frontdoor_route" "one" {
  cdn_frontdoor_custom_domain_ids = concat(
    [azurerm_cdn_frontdoor_custom_domain.domain.id],
  [for domain in azurerm_cdn_frontdoor_custom_domain.domains : domain.id])
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.one.id, azurerm_cdn_frontdoor_origin.one-dr.id]
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.one.id
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.ruleset.id]
  cdn_frontdoor_origin_path     = "/"
  forwarding_protocol           = "HttpsOnly"
  link_to_default_domain        = false
  name                          = "one-embark-${var.env_name}"
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  cache {
    query_string_caching_behavior = "UseQueryString"
    compression_enabled           = true
    content_types_to_compress     = ["application/eot", "application/font", "application/font-sfnt", "application/javascript", "application/opentype", "application/otf", "application/pkcs7-mime", "application/truetype", "application/ttf", "application/vnd.ms-fontobject", "application/xml", "application/xml+rss", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "application/x-httpd-cgi", "application/x-javascript", "application/x-mpegurl", "application/x-opentype", "application/x-otf", "application/x-perl", "application/x-ttf", "font/eot", "font/ttf", "font/otf", "font/opentype", "image/svg+xml", "text/css", "text/csv", "text/javascript", "text/js", "text/plain", "text/richtext", "text/tab-separated-values", "text/xml", "text/x-script", "text/x-component", "text/x-java-source"]
  }
  depends_on = [
    azurerm_cdn_frontdoor_endpoint.endpoint,
    azurerm_cdn_frontdoor_custom_domain.domain,
    azurerm_cdn_frontdoor_custom_domain.domains,
    azurerm_cdn_frontdoor_origin_group.one,
  ]
}

resource "azurerm_cdn_frontdoor_rule_set" "ruleset" {
  name                     = "one${replace(var.env_name, "-","")}ServerHeaderRuleSet"
  cdn_frontdoor_profile_id = var.afd_profile_id
}

resource "azurerm_cdn_frontdoor_rule" "deleterule" {
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.one,
    azurerm_cdn_frontdoor_origin.one
  ]

  name                      = "one${replace(var.env_name, "-","")}DeleteServerHeaders"
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
    azurerm_cdn_frontdoor_origin_group.one,
    azurerm_cdn_frontdoor_origin.one
  ]

  name                      = "one${replace(var.env_name, "-","")}AddSecurityHeaders"
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

resource "azurerm_dns_cname_record" "embark-dns" {
  provider            = azurerm.embarkdns
  name                = replace(var.primary_host_name, ".embark.ehr.com", "")
  zone_name           = "embark.ehr.com"
  resource_group_name = "hwcex-dns-zones"
  ttl                 = 86400
  target_resource_id  = azurerm_cdn_frontdoor_endpoint.endpoint.id
}
