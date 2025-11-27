# WidgetsAux App Service Plan: documentlibrary, configuration, contactus, managecontentadmins

resource "azurerm_app_service_plan" "widgetsaux" {
  name                = "${local.regioncodeprefix}widgetsaux${var.env_code}appsvcpln"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.appx_tags
  sku {
    tier     = var.app_service_plan_tier_widgetsaux
    size     = var.app_service_plan_size_widgetsaux
    capacity = var.app_service_plan_capacity_widgetsaux
  }
}

# configuration
resource "azurerm_app_service" "configuration" {
  name                = "${local.regioncodeprefix}configuration${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.widgetsaux.id
  https_only          = "true" # force https
  tags                = local.appx_tags
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

# appprovider - http://jira.ehr.com/browse/PEX-1157
resource "azurerm_app_service" "appprovider" {
  name                = "${local.regioncodeprefix}appprovider${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.widgetsaux.id
  https_only          = "true" # force https
  tags                = local.appx_tags
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