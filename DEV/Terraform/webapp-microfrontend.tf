resource "azurerm_app_service_plan" "microfrontend" {
  name                = "${local.regioncodeprefix}microfrontend${var.env_code}appsvcpln"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.appx_tags
  sku {
    tier     = var.app_service_plan_tier_microfrontend
    size     = var.app_service_plan_size_microfrontend
    capacity = var.app_service_plan_capacity_microfrontend # this will be the new AZDO variable
  }
}

resource "azurerm_app_service" "cltadmin" {
  name                = "${local.regioncodeprefix}cltadmin${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.microfrontend.id
  https_only          = "true" # force https
  tags                = local.appx_tags
  identity {
    type = "SystemAssigned"
  }
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0" # http://jira.ehr.com/browse/PEX-2591
    default_documents           = ["index.html"]
    # health_check_path = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
    http2_enabled = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
    ftps_state                  = "Disabled"     # Disable FTP 155204 - Guardrail 467
    scm_type                    = "None"         # Disable SCM 155204 - Guardrail 468
    # http://jira.ehr.com/browse/PEX-3703 - [DevOps] Create pipeline and add CORS in app service
    cors {
      allowed_origins     = local.cltadmin_cors
      support_credentials = "true"
    } # end cors
  }
}
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  