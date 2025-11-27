resource "azurerm_app_service_plan" "uiguide" {
  name                = "${local.regioncodeprefix}uiguide${var.env_code}appsvcpln"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.appx_tags
  sku {
    tier     = var.app_service_plan_tier_uiguide
    size     = var.app_service_plan_size_uiguide
    capacity = var.app_service_plan_capacity_uiguide
  }
}

# PEX-3589 - PullRequestComplianceChecker n21pexpullrequestcompliancecheckerdevfcn
resource "azurerm_function_app" "pullrequestcompliancechecker" {
  name                      = "${local.regioncodeprefix}pullrequestcompliancechecker${var.env_code}fcn"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.uiguide.id
  https_only                = "true" # Guardrail-50
  storage_connection_string = var.dnn_stg_conn_string
  version                   = "~4"
  tags                      = local.appx_tags
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    min_tls_version             = "1.2" # Guardrail-49
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0" # http://jira.ehr.com/browse/PEX-2591
    http2_enabled               = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
    ftps_state                  = "Disabled"     # Disable FTP 155204 - Guardrail 467
    scm_type                    = "None"         # Disable SCM 155204 - Guardrail 468
  }
}
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  // ...existing code...
# end 

# PEX-8082 - [DevOps] Clone n21pexpullrequestcompliancecheckerdevfcn
resource "azurerm_function_app" "oneembarkpullrequestcompliancechecker" {
  name                      = "${local.regioncodeprefix}oneembarkpullrequestcompliancechecker${var.env_code}fcn"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.uiguide.id
  https_only                = "true" # Guardrail-50
  storage_connection_string = var.dnn_stg_conn_string
  version                   = "~4"
  tags                      = local.appx_tags
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    min_tls_version             = "1.2" # Guardrail-49
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0" # http://jira.ehr.com/browse/PEX-2591
    http2_enabled               = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
    ftps_state                  = "Disabled"     # Disable FTP 155204 - Guardrail 467
    scm_type                    = "None"         # Disable SCM 155204 - Guardrail 468
  }
}
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
# end 

# # SSO Checker Function App
# resource "azurerm_function_app" "ssochecker" {
#   name                      = "${local.regioncodeprefix}ssochecker${var.env_code}fcn"
#   location                  = var.location
#   resource_group_name       = var.resource_group_name
#   app_service_plan_id       = azurerm_app_service_plan.uiguide.id
#   https_only                = "true" # Guardrail-50
#   storage_connection_string = var.dnn_stg_conn_string
#   version                   = "~4"
#   tags                      = local.appx_tags
#   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
#   site_config {
#     always_on                   = "true"
#     min_tls_version             = "1.2" # Guardrail-49
#     scm_use_main_ip_restriction = "true"
#     dotnet_framework_version    = "v6.0" # http://jira.ehr.com/browse/PEX-2591
#     http2_enabled               = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
#     ftps_state                  = "FtpsOnly" # Azure GR 358 - Function apps must require FTPS only
#   }
#   # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
#   # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
#   lifecycle {
#     ignore_changes = [
#       site_config["scm_type"]
#     ]
#   }
# }
# # end 