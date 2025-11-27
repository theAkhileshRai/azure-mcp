resource "azurerm_web_application_firewall_policy" "embarkwaf" {
  name                = #{waf_policy_name}#
  resource_group_name = #{resource_group_name}#
  location            = #{location}#

  custom_rules {
    name      = "DovetailFileAttachments"
    priority  = 100
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }

      operator           = "BeginsWith"
      negation_condition = false
      match_values       = ["/integrationdovetail/api/"]
    }

    action = "Allow"
  }

  # Temporary WAF Custom Rules for EmbarkStandard
  custom_rules {
    name      = "EmbarkStandardAPIs"
    priority  = 99
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/std-"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }
  
  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 750
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    exclusion {
      match_variable          = "RequestArgNames"
      selector                = "code"
      selector_match_operator = "Equals"
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.1"
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        disabled_rules = [
          "920300",
          "920320"
        ]
      }

      rule_group_override {
        rule_group_name = "REQUEST-921-PROTOCOL-ATTACK"
        disabled_rules = [
          "921151"
        ]
      }

      rule_group_override {
        rule_group_name = "REQUEST-932-APPLICATION-ATTACK-RCE"
        disabled_rules = [
          "932110"
        ]
      }

      rule_group_override {
        rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
        disabled_rules = [
          "941330",
          "941340"
        ]
      }

      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        disabled_rules = [
          "942100",
          "942120",
          "942130",
          "942150",
          "942200",
          "942260",
          "942370",
          "942410",
          "942430",
          "942440"
        ]
      }
    }
  }

  tags = {
        "AppID" = #{AppID}#
        "IAC"   = #{IACTag}#
    }

}