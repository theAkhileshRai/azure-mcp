# Infocenter App Service Plan: infocenter, faq, definitions, findoutmore

resource "azurerm_app_service_plan" "infocenter" {
  name                = "${local.regioncodeprefix}infocenter${var.env_code}appsvcpln"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.sa_tags
  sku {
    tier     = var.app_service_plan_tier_infocenter
    size     = var.app_service_plan_size_infocenter
    capacity = var.app_service_plan_capacity_infocenter
  }
}
# end 

# PEX-2475 - Pipeline and App service for Embark Support tool
resource "azurerm_app_service" "supportapp" {
  name                = "${local.regioncodeprefix}supportapp${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.infocenter.id
  https_only          = "true" # force https
  tags                = local.sa_tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.usermanagedidentity.id
    ]
  }
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0"         # http://jira.ehr.com/browse/PEX-2591
    health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
    http2_enabled               = "true"         # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
  }
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  lifecycle {
    ignore_changes = [
      site_config["scm_type"]
    ]
  }
}
# end 

resource "azurerm_app_service" "samlapi" { # PEX-3060 - SAML service - new repo, app service and pipeline
  name                = "${local.regioncodeprefix}samlapi${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.infocenter.id
  https_only          = "true" # force https
  tags                = local.sa_tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.usermanagedidentity.id
    ] 
  }
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0" # http://jira.ehr.com/browse/PEX-2591
    health_check_path           = "/api/isalive"
    http2_enabled               = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
  }
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  lifecycle {
    ignore_changes = [
      site_config["scm_type"]
    ]
  }
}
# end 

resource "azurerm_app_service" "samltest" { # PEX-3449 - Include SAML Test in IaC-Terraform codes
  name                = "${local.regioncodeprefix}samltest${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.infocenter.id
  https_only          = "true" # force https
  tags                = local.sa_tags
  identity {
    type = "SystemAssigned"
  }
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0" # http://jira.ehr.com/browse/PEX-2591
    # health_check_path = "/api/isalive" 
  }
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  lifecycle {
    ignore_changes = [
      site_config["scm_type"]
    ]
  }
}
# end 
