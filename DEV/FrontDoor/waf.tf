resource "azurerm_cdn_frontdoor_firewall_policy" "policy" {
  custom_block_response_body        = "Rm9yYmlkZGVu"
  custom_block_response_status_code = 403
  mode                              = var.frontdoor_waf_mode
  name                              = replace("${local.frontdoor_name}waf", "-", "")
  resource_group_name               = azurerm_resource_group.resource-group.name
  sku_name                          = "Premium_AzureFrontDoor"
  tags                              = merge({}, var.default_tags)

  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"]]
  }

  custom_rule {
    name                           = "AllowAXD"
    enabled                        = true
    priority                       = 1
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "MatchRule"
    action                         = "Allow"

    match_condition {
      match_variable     = "RequestUri"
      operator           = "Contains"
      negation_condition = false
      match_values       = ["webresource.axd", "scriptresource.axd"]
      selector           = null
      transforms         = ["Lowercase"]
    }
  }

  custom_rule {
    name                           = "QueryStrings"
    enabled                        = true
    priority                       = 20
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

  custom_rule {
    name                           = "PostArgsContent"
    enabled                        = true
    priority                       = 3
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "MatchRule"
    action                         = "Allow"

    match_condition {
      match_variable     = "PostArgs"
      operator           = "Any"
      negation_condition = false
      transforms         = ["Lowercase"]
      selector           = "content"
      match_values       = []
    }
  }

  custom_rule {
    name                           = "RequestBodyContent"
    enabled                        = true
    priority                       = 6
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "MatchRule"
    action                         = "Allow"

    match_condition {
      match_variable     = "RequestBody"
      operator           = "Contains"
      negation_condition = false
      transforms         = ["Lowercase"]
      match_values       = ["content"]
    }
  }

  custom_rule {
    name                           = "PostArgsDnn"
    enabled                        = true
    priority                       = 4
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "MatchRule"
    action                         = "Allow"

    match_condition {
      match_variable     = "PostArgs"
      operator           = "Any"
      negation_condition = false
      transforms         = ["Lowercase"]
      selector           = "dnn"
      match_values       = []
    }
  }
  
  custom_rule {
    name                           = "AllowSpecificUris"
    enabled                        = true
    priority                       = 7
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "MatchRule"
    action                         = "Allow"

     match_condition {
      match_variable     = "RequestUri"
      operator           = "Contains"
      negation_condition = false
      match_values       = ["HtmlTextPro", "SaveSamlEntity", "SavePackageSettings"]
      selector           = null
      transforms         = []
    }
  }
  custom_rule {
    name                           = "BlockBotBotsUserAgent"
    enabled                        = true
    priority                       = 10
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "MatchRule"
    action                         = "Block"

    match_condition {
      match_variable     = "RequestHeader"
      operator           = "Contains"
      negation_condition = false
      match_values       = ["bingbot"]
      selector           = "User-Agent"
      transforms         = ["Lowercase"]
    }
  }
  
  custom_rule {
    name                           = "BlockBotBotsUserDashAgent"
    enabled                        = true
    priority                       = 11
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "MatchRule"
    action                         = "Block"

     match_condition {
      match_variable     = "RequestHeader"
      operator           = "Contains"
      negation_condition = false
      match_values       = ["bingbot"]
      selector           = "UserAgent"
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
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "_"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "_"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "Items"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "Items"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "Contains"
      selector       = "Date"
    }

    exclusion {
      match_variable = "RequestCookieNames"
      operator       = "EqualsAny"
      selector       = "*"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "Answer"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "Answer"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "Article"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "Header"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "Html"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "Body"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "Body"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "StartsWith"
      selector       = "Token"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "Token"
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

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "Equals"
      selector       = "TimeZoneName"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "Saml"
    }

    exclusion {
      match_variable = "QueryStringArgNames"
      operator       = "Equals"
      selector       = "dl"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "PortalAssets"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "Equals"
      selector       = "FederationXml"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "Equals"
      selector       = "state"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "Note"
    }

    exclusion {
      match_variable = "RequestBodyPostArgNames"
      operator       = "Equals"
      selector       = "postfile"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "StartsWith"
      selector       = "Icon"
    }

    exclusion {
      match_variable = "RequestBodyJsonArgNames"
      operator       = "Contains"
      selector       = "ushSubscription"
    }

    override {
      rule_group_name = "PROTOCOL-ENFORCEMENT"

      exclusion {
        match_variable = "RequestBodyJsonArgNames"
        operator       = "StartsWith"
        selector       = "AskHr"
      }

      exclusion {
          match_variable = "RequestHeaderNames"
          operator       = "Equals"
          selector       = "user-agent"
        }

      rule {
        rule_id = "920230"
        action  = "AnomalyScoring"
        enabled = true

        # exclusion {
        #   match_variable = "QueryStringArgNames"
        #   operator       = "Equals"
        #   selector       = "state"
        # }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "StartsWith"
          selector       = "ApiLink"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "d"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "m"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "StartsWith"
          selector       = "file"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Contains"
          selector       = "Image"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Contains"
          selector       = "Search"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "StartsWith"
          selector       = "DOMIdentifiers"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "TaggedLink.TargetLink"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "FileTicket"
        }

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

      rule {
        rule_id = "920270"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestHeaderNames"
          operator       = "Equals"
          selector       = "dnn_IsMobile"
        }

        exclusion {
          match_variable = "RequestCookieNames"
          operator       = "Equals"
          selector       = "ApplicationGatewayAffinityCORS"
        }
      }

      rule {
        rule_id = "920271"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestCookieNames"
          operator       = "Equals"
          selector       = "ApplicationGatewayAffinityCORS"
        }
      }

      rule {
        rule_id = "920320"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestHeaderNames"
          operator       = "Equals"
          selector       = "0"
        }
      }
      
    }

    # override {
    #   rule_group_name = "PROTOCOL-ATTACK"

    #   rule {
    #     rule_id = "921110"
    #     action  = "AnomalyScoring"
    #     enabled = true

    #     //This might be wrong, logs are unclear on the type of request it is
    #     //https://jira.ehr.com/browse/PCS-7014
    #     exclusion {
    #       match_variable = "RequestBodyPostArgNames"
    #       operator       = "Equals"
    #       selector       = "InitialBodyContents"
    #     }
    #   }
    # }

    override {
      rule_group_name = "RCE"

      # rule {
      #   rule_id = "932100"
      #   action  = "AnomalyScoring"
      #   enabled = true

      #   //This should be caught in the custom rule "RequestBodyContent"
      #   exclusion {
      #     match_variable = "RequestBodyPostArgNames"
      #     operator       = "StartsWith"
      #     selector       = "content1"
      #   }
      # }

      # rule {
      #   rule_id = "932140"
      #   action  = "AnomalyScoring"
      #   enabled = true
      # }

      rule {
        rule_id = "932150"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "query"
        }
        
        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "SearchKeyWord"
        }
      }
    }

    override {
      rule_group_name = "RFI"

      rule {
        rule_id = "931130"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "CookieMoreLink"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "StartsWith"
          selector       = "EndPoint"
        }

        exclusion {
          match_variable = "RequestBodyPostArgNames"
          operator       = "Equals"
          selector       = "RelayState"
        }

        exclusion {
          match_variable = "QueryStringArgNames"
          operator       = "Equals"
          selector       = "travelpayouts_redirect"
        }

        exclusion {
          match_variable = "QueryStringArgNames"
          operator       = "Equals"
          selector       = "next"
        }

        exclusion {
          match_variable = "QueryStringArgNames"
          operator       = "Equals"
          selector       = "Source"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "TaggedLink.TargetLink"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Contains"
          selector       = "Url"
        }
        exclusion {
         match_variable = "RequestBodyJsonArgNames"
         operator       = "Equals"
         selector       = "surveyURL"
        }
      }
    }

    override {
      rule_group_name = "PHP"

      rule {
        rule_id = "933210"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "fileName"
        }
      }
    }

    override {
      rule_group_name = "SQLI"

      exclusion {
        match_variable = "RequestBodyPostArgNames"
        operator       = "Equals"
        selector       = "SAMLResponse"
      }
      exclusion {
        match_variable = "RequestBodyPostArgNames"
        operator       = "Equals"
        selector       = "id_token"
      }
      exclusion {
        match_variable = "RequestBodyPostArgNames"
        operator       = "Equals"
        selector       = "access_token"
      }

      rule {
        rule_id = "942100"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Contains"
          selector       = "FileTicket"
        }
      }

      rule {
        rule_id = "942120"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Contains"
          selector       = "Pages"
        }
        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Contains"
          selector       = "ConnectionString"
        }
      }

      rule {
        rule_id = "942200"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyPostArgNames"
          operator       = "Equals"
          selector       = "Value"
        }
      }

      rule {
        rule_id = "942210"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "FileRelativePath"
        }
      }

      rule {
        rule_id = "942380"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "query"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "CaseType"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "Description"
        }
      }

      rule {
        rule_id = "942410"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "StartsWith"
          selector       = "DateUpdated"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "TimeZoneId"
        }
        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "name"
        }
      }

      # rule {
      #   rule_id = "942450"
      #   action  = "AnomalyScoring"
      #   enabled = true

      #   exclusion {
      #     match_variable = "RequestBodyPostArgNames"
      #     operator       = "Equals"
      #     selector       = "access_token"
      #   }
      # }
    }

    override {
      rule_group_name = "XSS"

      exclusion {
        match_variable = "RequestBodyJsonArgNames"
        operator       = "StartsWith"
        selector       = "Custom"
      }

      rule {
        rule_id = "941100"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "QueryStringArgNames"
          operator       = "Equals"
          selector       = "helpkey"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "Description"
        }
      }

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

      rule {
        rule_id = "941120"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "FileTicket"
        }
      }

      rule {
        rule_id = "941170"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "OnNetworkUrl"
        }
      }

      rule {
        rule_id = "941210"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "OnNetworkUrl"
        }
      }

      rule {
        rule_id = "941320"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyPostArgNames"
          operator       = "StartsWith"
          selector       = "Dashboard"
        }

        exclusion {
          match_variable = "RequestBodyPostArgNames"
          operator       = "Equals"
          selector       = "Description"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "Description"
        }
      }
    }


    override {
      rule_group_name = "MS-ThreatIntel-SQLI"

      # exclusion {
      #   match_variable = "RequestBodyJsonArgNames"
      #   operator       = "Equals"
      #   selector       = "ArticleContent"
      # }

      rule {
        rule_id = "99031001"
        action  = "AnomalyScoring"
        enabled = true

      exclusion {
          match_variable = "QueryStringArgNames"
          operator       = "Equals"
          selector       = "classname"
        }
      }

      rule {
        rule_id = "99031002"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "FilterKeyword"
        }

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "Title"
        }
      }

      rule {
        rule_id = "99031003"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "StartsWith"
          selector       = "DateUpdated"
        }
        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "name"
        }
      }

      rule {
        rule_id = "99031004"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyJsonArgNames"
          operator       = "Equals"
          selector       = "CustomMessage"
        }
      }
    }
    override {
      rule_group_name = "LFI"
      rule {
        rule_id = "930120"
        action  = "AnomalyScoring"
        enabled = true

        exclusion {
          match_variable = "RequestBodyPostArgNames"
          operator       = "Equals"
          selector       = "id_token"
        }
        exclusion {
          match_variable = "RequestBodyPostArgNames"
          operator       = "Equals"
          selector       = "access_token"
        }
      }
    }
  }

  managed_rule {
    action  = "Block"
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  
   override {
    rule_group_name = "GoodBots"
     rule {
      rule_id = "Bot200100"  # Block GoodBots
      enabled = true
      action  = "Block"
    }
   }
  }

  depends_on = [
    azurerm_resource_group.resource-group,
  ]
}
