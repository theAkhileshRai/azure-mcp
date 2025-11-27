/* 
### NOTES ###
WAF policy MUST be in the same region as the WAF
terraform https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/web_application_firewall_policy
MS notes: https://docs.microsoft.com/en-us/azure/web-application-firewall/ag/create-waf-policy-ag
*/

resource "azurerm_web_application_firewall_policy" "waf" {
  name                = "${var.agw_name}-waf"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.appx_tags

  policy_settings {
    enabled                     = true
    mode                        = "Prevention" # PEX-3130
    request_body_check          = true         # PEX-2673 / PEX-6669 - Azure GuardRails 335 - Application Gateway WAF Policies must enable the Policy settings Inspect request body for externally facing applications
    file_upload_limit_in_mb     = 4000
    max_request_body_size_in_kb = 2000 # 128 is max
  }

  # PEX-3130
  # custom rules
  # this rule allows the path (WAF won't block it)
  # Once a rule is matched, the corresponding action defined in the rule is applied to the request. Once such a match is processed, rules with lower priorities are not processed further. A smaller integer value for a rule denotes a higher priority.

  # Block/Deny Traffic Rule
  custom_rules {
    name      = "DenyTraffic"
    priority  = 1
    action    = "Block"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/.git",
        "/.env",
        "/importmap.backup" # https://jira.ehr.com/browse/PEX-6125 - Pen Test 2023 - embark-uat.ehr.com  - Info - Possible Backup or Sensitive File Enumeration
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow /api/registration/translation -> Allow Translation API calls due to WAF RuleId 920470
  custom_rules {
    name      = "AllowTranslationAPI"
    priority  = 10
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/registration/translation"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  custom_rules {
    name      = "Allow942440"
    priority  = 11
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/emptycc"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  custom_rules {
    name      = "Allow933210"
    priority  = 12
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/home"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  custom_rules {
    name      = "Allow931130"
    priority  = 13
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/pushnotifications",
        "/usermigration"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  custom_rules {
    name      = "Allow942430"
    priority  = 14
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/clientadmin"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  custom_rules {
    name      = "AllowJira"
    priority  = 15
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/jira",
        "/api/Jira"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow /api/registration -> Allow ContactUs/Submit due to WAF RuleId 200003
  custom_rules {
    name      = "AllowRegistrationAPI"
    priority  = 20
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/registration",
        "/lookup/self-identification"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow RegistrationUI URI Paths
  custom_rules {
    name      = "AllowRegistration"
    priority  = 21
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/login",
        "/notices",
        "/mfe-login" # need to add this
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow URis due to WAF RuleId 920300
  custom_rules {
    name      = "Allow920300"
    priority  = 30
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/apple-app-site-association",
        "/.well-known/assetlinks.json"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow URis due to WAF RuleId 920320
  custom_rules {
    name      = "Allow920320"
    priority  = 40
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/.well-known/security.txt",
        "/.well-known/keys",
        "/.well-known/openid-configuration",
        "/api/v2",
        "/api/v1",
        "/api/users"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow Configuration APIs
  custom_rules {
    name      = "AllowConfigurationAPI"
    priority  = 50
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/config",
        "/api/Config"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow ActionList APIs
  custom_rules {
    name      = "AllowActionListAPI"
    priority  = 51
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/ActionList/ManageActionList",
        "/api/actionlist/manageactionlist"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow Authentication APIs
  custom_rules {
    name      = "AllowAuthenticationAPI"
    priority  = 52
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/Authentication/Members",
        "/api/authentication/members"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow FindOutMore APIs
  custom_rules {
    name      = "AllowFindOutMoreAPI"
    priority  = 53
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/FindOutMore/ManageFindOutMore",
        "/api/findoutmore/managefindoutmore"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow QuickLinks APIs
  custom_rules {
    name      = "AllowQuickLinksAPI"
    priority  = 54
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/QuickLinks/ManageQuickLinks",
        "/api/quicklinks/managequicklinks"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow Resource APIs
  custom_rules {
    name      = "AllowResourceAPI"
    priority  = 55
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/Resource/ManageResources",
        "/api/resource/manageresources"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow WelcomeBanner APIs
  custom_rules {
    name      = "AllowWelcomeBannerAPI"
    priority  = 56
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/WelcomeBanner/ManageWelcomeBanner",
        "/api/welcomebanner/managewelcomebanner"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow WellbeingResources APIs
  custom_rules {
    name      = "AllowWellbeingResourcesAPI"
    priority  = 57
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/WellbeingResources/ManageWellbeingResources",
        "/api/wellbeingresources/managewellbeingresources"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow FAQ APIs
  custom_rules {
    name      = "AllowFAQAPI"
    priority  = 58
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/FAQ/ManageFAQ",
        "/api/faq/managefaq"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow Definitions APIs
  custom_rules {
    name      = "AllowDefinitionsAPI"
    priority  = 59
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/Definition/ManageDefinitions",
        "/api/definition/managedefinitions"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow ContactUs APIs
  custom_rules {
    name      = "AllowContactUsAPI"
    priority  = 60
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/ContactUsWidget/ManageContactUsWidget",
        "/api/contactuswidget/managecontactuswidget",
        "/api/ContactUs",
        "/api/contactus"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow CustomPages APIs
  custom_rules {
    name      = "AllowCustomPagesAPI"
    priority  = 61
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/CustomPages/CustomPages",
        "/api/custompages/custompages"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # Allow DocumentLibrary APIs
  custom_rules {
    name      = "AllowDocumentLibraryAPI"
    priority  = 62
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/docLibrary/FileManager",
        "/api/docLibrary/fileManager"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  custom_rules {
    name      = "AllowB2CSamlAPI"
    priority  = 63
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/b2csaml/outbound",
        "/api/B2CSaml/Outbound",
        "/api/b2csaml/manage"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  custom_rules {
    name      = "AllowSharedComponentsAPI"
    priority  = 64
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/SharedComponents/ManageUrlMapping",
        "/api/sharedcomponents/manageurlmapping"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  custom_rules {
    name      = "AllowBenefitsEngineAPI"
    priority  = 65
    action    = "Allow"
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      match_values = [
        "/api/BenefitsGuide",
        "/api/benefitsguide"
      ]
      negation_condition = false
      operator           = "Contains"
      transforms = [
        "Lowercase",
      ]
    }
  }

  # OWASP rule set and exclusions
  # For a list of OWASP Rule group names: https://docs.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules?tabs=owasp31#owasp-crs-31
  # NOTE: Specific exclusion is available in AzureRM v3.19.0: https://registry.terraform.io/providers/hashicorp/azurerm/3.19.0/docs/resources/web_application_firewall_policy
  # NOTE: Rule Id block is available in Azure RM v3.36.0: https://registry.terraform.io/providers/hashicorp/azurerm/3.36.0/docs/resources/web_application_firewall_policy#rule
  managed_rules {
    exclusion { # Fixes for OWASP 3.2 RuleId 920320, 942210, 942430, 942450, 942440
      match_variable          = "RequestArgNames"
      selector                = "state"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 920300, 920320
      match_variable          = "RequestHeaderNames"
      selector                = "User-Agent"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 920470
      match_variable          = "RequestCookieNames"
      selector                = "Content_Type"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 931130
      match_variable          = "RequestArgNames"
      selector                = "b2cBaseUrl"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 931130
      match_variable          = "RequestArgNames"
      selector                = "redirect_uri"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 931130
      match_variable          = "RequestArgNames"
      selector                = "cancel_redirect_uri"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 931130
      match_variable          = "RequestArgNames"
      selector                = "targetUrl"
      selector_match_operator = "Contains"
    }
    # exclusion { # Fixes for OWASP 3.2 RuleId 931130
    #   match_variable          = "RequestArgValues" # Not supported until in AzureRM v3.24.0: https://registry.terraform.io/providers/hashicorp/azurerm/3.24.0/docs/resources/web_application_firewall_policy
    #   selector                = "https:"
    #   selector_match_operator = "Contains"
    # }
    exclusion { # Fixes for OWASP 3.2 RuleId 942210, 942430, 942450
      match_variable          = "RequestArgNames"
      selector                = "code"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 942210, 942430, 942440
      match_variable          = "RequestArgNames"
      selector                = "Correlation"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 942210, 942430, 942440, # PEX-4615 Add a WAF exclusion to OWASP 3.1 rule ID 921151
      match_variable          = "RequestArgNames"
      selector                = "error_description"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 942430, 942440, 942450
      match_variable          = "RequestCookieNames"
      selector                = "token"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 942430, 942440, 942450
      match_variable          = "RequestCookieNames"
      selector                = "OptanonConsent"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 942430
      match_variable          = "RequestArgNames"
      selector                = "fileName"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 942210, 942430, 942440, 942450
      match_variable          = "RequestArgNames"
      selector                = "token"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 942210, 942430, 942440, 942450
      match_variable          = "RequestArgNames"
      selector                = "id_token"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 RuleId 920320, 942450
      match_variable          = "RequestCookieNames"
      selector                = "OneTrustToken"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 Global
      match_variable          = "RequestCookieNames"
      selector                = "x-ms-cpim"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 Global
      match_variable          = "RequestCookieNames"
      selector                = "esctx"
      selector_match_operator = "Contains"
    }
    exclusion { # Fixes for OWASP 3.2 Global
      match_variable          = "RequestCookieNames"
      selector                = "__RequestVerificationToken"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 Global
      match_variable          = "RequestCookieNames"
      selector                = "bnfsaApplicationCookie"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 Global
      match_variable          = "RequestCookieNames"
      selector                = "bnfsaSsoSessionCookie"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 Global
      match_variable          = "RequestCookieNames"
      selector                = "ssm_au"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 Global
      match_variable          = "RequestArgNames"
      selector                = "deviceId"
      selector_match_operator = "Equals"
    }
    exclusion { # Fixes for OWASP 3.2 Global
      match_variable          = "RequestCookieNames"
      selector                = "SessionId"
      selector_match_operator = "Equals"
    }
    exclusion { # For cookies set from AppInsights: https://stackoverflow.com/questions/70826955/what-are-ai-user-and-ai-session-cookies-in-asp-net-core-identity-and-how-to-conf
      match_variable          = "RequestCookieNames"
      selector                = "ai_user"
      selector_match_operator = "Equals"
    }
    exclusion { # For cookies set from AppInsights: https://stackoverflow.com/questions/70826955/what-are-ai-user-and-ai-session-cookies-in-asp-net-core-identity-and-how-to-conf
      match_variable          = "RequestCookieNames"
      selector                = "ai_session"
      selector_match_operator = "Equals"
    }
    exclusion { # https://jira.ehr.com/browse/PEX-8466
      match_variable          = "RequestCookieNames"
      selector                = "wtw-sa-auth-xsrf"
      selector_match_operator = "Equals"
    }
    managed_rule_set {
      type    = "OWASP"
      version = "3.2" # PEX-3130 - Upgrade to OWASP 3.2

    } # end managed_rule_set
  }   # end managed_rules

  lifecycle { # Igore Rule Block to not override Action Type = Log
    ignore_changes = [
      managed_rules[0]
    ]
  }


}
