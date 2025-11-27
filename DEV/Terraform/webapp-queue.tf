# http://jira.ehr.com/browse/PEX-2248

resource "azurerm_app_service_plan" "queue" {
  name                = "${local.regioncodeprefix}queue${var.env_code}svcpln"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.sa_tags
  sku {
    tier     = var.app_service_plan_tier_queue
    size     = var.app_service_plan_size_queue
    capacity = var.app_service_plan_capacity_queue # this will be the new AZDO variable
  }
}

resource "azurerm_app_service" "queueapi" {
  name                = "${local.regioncodeprefix}queueapi${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.queue.id
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
      site_config["scm_type"]
    ]
  }
}

resource "azurerm_app_service" "kbaapi" { # http://jira.ehr.com/browse/PEX-3630 - Create New Repository - KBA API
  name                = "${local.regioncodeprefix}kbaapi${var.env_code}appsvc"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.queue.id
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
    # health_check_path = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
    http2_enabled = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
  }
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  lifecycle {
    ignore_changes = [
      site_config["scm_type"]
    ]
  }
}