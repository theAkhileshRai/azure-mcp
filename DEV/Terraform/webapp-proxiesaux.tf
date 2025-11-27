# App Service Plan for New Proxies

## Decommissioning Resource: [proxiesaux]
## Reason: PEX-9049 Remove Empty App Service Plans
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.

## resource "azurerm_app_service_plan" "proxiesaux" {
##   name                = "${local.regioncodeprefix}proxiesaux${var.env_code}appsvcpln"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   tags                = local.sa_tags
##   sku {
##     tier     = var.app_service_plan_tier_proxiesaux
##     size     = var.app_service_plan_size_proxiesaux
##     capacity = var.app_service_plan_capacity_proxiesaux
##   }
## }

## Decommissioning Resource: [proxyfrenchbenefits]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context

# https://jira.ehr.com/browse/PEX-6456 - Create App Service and Pipelines for French Benefits
## resource "azurerm_app_service" "proxyfrenchbenefits" {
##   name                = "${local.regioncodeprefix}proxyfrenchbenefits${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxiesaux.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0" # PEX-2591 - DevOps - Upgrade AppEx App Services to .NET 6
##     # Disable healthcheck for now since French Benefits doesn't have API healthcheck path yet
##     # health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
##   }
##   # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
##   # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
##   lifecycle {
##     ignore_changes = [
##       site_config["scm_type"]
##     ]
##   }
## }
## # end

## Decommissioning Resource: [proxysettlementportal]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context
# PEX-6708 - Create App Service and Pipelines for Settlement Portal

## resource "azurerm_app_service" "proxysettlementportal" {
##   name                = "${local.regioncodeprefix}proxysettlementportal${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxiesaux.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0" # PEX-2591 - DevOps - Upgrade AppEx App Services to .NET 6
##     # Disable healthcheck for now since French Benefits doesn't have API healthcheck path yet
##     # health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
##   }
##   # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
##   # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
##   lifecycle {
##     ignore_changes = [
##       site_config["scm_type"]
##     ]
##   }
## }
## # end
## Decommissioning Resource: [proxyembarkcontentportal]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context

## # PEX-6713 - Create App Service and Pipelines for Content Portal
## resource "azurerm_app_service" "proxyembarkcontentportal" {
##   name                = "${local.regioncodeprefix}proxyembarkcontentportal${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxiesaux.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0" # PEX-2591 - DevOps - Upgrade AppEx App Services to .NET 6
##     # Disable healthcheck for now since French Benefits doesn't have API healthcheck path yet
##     # health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
##   }
##   # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
##   # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
##   lifecycle {
##     ignore_changes = [
##       site_config["scm_type"]
##     ]
##   }
## }
## # end

## Decommissioning Resource: [proxybenefitsconnect]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context

## # PEX-7277 - [DevOps] Create new app service for WTW.EX.Proxy.BenefitsConnect and WTW.EX.Proxy.Lifesight
## resource "azurerm_app_service" "proxybenefitsconnect" {
##   name                = "${local.regioncodeprefix}proxybenefitsconnect${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxiesaux.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0" # PEX-2591 - DevOps - Upgrade AppEx App Services to .NET 6
##     # Disable healthcheck for now since French Benefits doesn't have API healthcheck path yet
##     # health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
##   }
##   # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
##   # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
##   lifecycle {
##     ignore_changes = [
##       site_config["scm_type"]
##     ]
##   }
## }
## # end

## Decommissioning Resource: [proxylifesight]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context

## # PEX-7277 - [DevOps] Create new app service for WTW.EX.Proxy.BenefitsConnect and WTW.EX.Proxy.Lifesight
## resource "azurerm_app_service" "proxylifesight" {
##   name                = "${local.regioncodeprefix}proxylifesight${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxiesaux.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0" # PEX-2591 - DevOps - Upgrade AppEx App Services to .NET 6
##     # Disable healthcheck for now since French Benefits doesn't have API healthcheck path yet
##     # health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled = "true" # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
##   }
##   # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
##   # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
##   lifecycle {
##     ignore_changes = [
##       site_config["scm_type"]
##     ]
##   }
## }
## # end
