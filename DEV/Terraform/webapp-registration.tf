resource "azurerm_app_service_plan" "registration" {
  name                = "${local.regioncodeprefix}registration${var.env_code}svcpln"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.sa_tags
  sku {
    tier     = var.app_service_plan_tier_registration
    size     = var.app_service_plan_size_registration
    capacity = var.app_service_plan_capacity_registration # this will be the new AZDO variable
  }
}

# 5 resources:
# - registration UI
# - registration API
# - translation UI
# - b2cext

resource "azurerm_app_service" "registrationui" {
  name                = "${local.regioncodeprefix}registrationui${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.registration.id
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
    dotnet_framework_version    = "v6.0"        # http://jira.ehr.com/browse/PEX-2591
    health_check_path           = "/index.html" # PEX-3137 - Enable AppSvc Health Check
    http2_enabled               = "true"        # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
  }
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  lifecycle {
    ignore_changes = [
      site_config["scm_type"]
    ]
  }
}

resource "azurerm_app_service" "registrationapi" {
  name                = "${local.regioncodeprefix}registrationapi${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.registration.id
  https_only          = "true" # force https
  tags                = local.sa_tags
  identity {
    type = "SystemAssigned, UserAssigned"
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

# b2cext
resource "azurerm_app_service" "b2cext" {
  name                = "${local.regioncodeprefix}b2cext${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.registration.id
  https_only          = "true" # force https
  tags                = local.sa_tags
  identity {
    type = "SystemAssigned"
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
      site_config["scm_type"],
      tags # ignoring "tags" since terraform is always trying to remove the tag "hidden-link: /app-insights-resource-id" which does not remove the connection to app insights if removed but always shows as a change in plan output
    ]
  }
}
# end

# translationui
resource "azurerm_app_service" "translationui" {
  name                = "${local.regioncodeprefix}translationui${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.widgetsaux.id
  https_only          = "true" # force https
  tags                = local.appx_tags
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.usermanagedidentity.id
    ]
  }
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0" # http://jira.ehr.com/browse/PEX-2591
    health_check_path           = "/"    # PEX-3137 - Enable AppSvc Health Check
    http2_enabled               = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
    ftps_state                  = "Disabled"     # Disable FTP 155204 - Guardrail 467
    scm_type                    = "None"         # Disable SCM 155204 - Guardrail 468
  }
}
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
# end
