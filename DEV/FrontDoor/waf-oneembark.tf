resource "azurerm_cdn_frontdoor_firewall_policy" "oneembark-policy" {
  custom_block_response_body        = "Rm9yYmlkZGVu"
  custom_block_response_status_code = 403
  mode                              = var.frontdoor_waf_mode_oneembark
  name                              = replace("${local.frontdoor_name}ptlonewaf", "-", "")
  resource_group_name               = azurerm_resource_group.resource-group.name
  sku_name                          = "Premium_AzureFrontDoor"
  tags                              = merge({}, var.default_tags)

  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"]]
  }

  custom_rule {
    name                           = "QueryStrings"
    enabled                        = true
    priority                       = 2
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "MatchRule"
    action                         = "Allow"

    match_condition {
      match_variable     = "QueryString"
      operator           = "Contains"
      negation_condition = false
      match_values       = ["code", "url", "state", "search", "uri", "token", "id", "value", "file", "ver"]
      transforms         = ["Lowercase"]
    }
  }

  managed_rule {
    action  = "Block"
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"

    //QueryStringArgNames
    //RequestBodyPostArgNames
    //RequestCookieNames
    //RequestHeaderNames
    //RequestBodyJsonArgNames

    //Equals
    //Contains
    //StartsWith
    //EndsWith
    //EqualsAny

    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "EqualsAny"
      selector       = "*"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "Contains"
      selector       = "url"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "url"
    }

    override {
      rule_group_name = "PROTOCOL-ENFORCEMENT"

      exclusion {
          match_variable = "RequestHeaderNames"
          operator       = "Equals"
          selector       = "user-agent"
        }

      rule {
        rule_id = "920230"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Contains"
          selector       = "Url"
        }
      }

      rule {
        rule_id = "920240"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestHeaderNames"
          operator       = "Equals"
          selector       = "Content-Type"
        }
      }
    }

    override {
      rule_group_name = "SQLI"

      rule {
        rule_id = "942380"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "query"
        }
      }
    }

    override {
      rule_group_name = "XSS"

      rule {
        rule_id = "941101"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestHeaderNames"
          operator       = "Equals"
          selector       = "Referer"
        }
      }
    }
  }

  managed_rule {
    action  = "Block"
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }
}
