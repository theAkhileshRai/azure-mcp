# App Service Plan for Proxies

## Decommissioning Resource: [proxies]
## Reason: PEX-9049 Remove Empty App Service Plans
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.

## resource "azurerm_app_service_plan" "proxies" {
##   name                = "${local.regioncodeprefix}proxies${var.env_code}appsvcpln"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   tags                = local.sa_tags
##   sku {
##     tier     = var.app_service_plan_tier_proxies
##     size     = var.app_service_plan_size_proxies
##     capacity = var.app_service_plan_capacity_proxies
##   }
## }

# resource "azurerm_app_service_plan" "proxiesba" {
#   name                = "${local.regioncodeprefix}proxiesba${var.env_code}appsvcpln"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = local.sa_tags
#   sku {
#     tier     = var.app_service_plan_tier_proxiesba
#     size     = var.app_service_plan_size_proxiesba
#     capacity = var.app_service_plan_capacity_proxiesba
#   }
# }
## Decommissioning Resource: [proxybenefitsengine]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context

## # Proxy Benefits Engine App Service - http://jira.ehr.com/browse/PEX-1445
## resource "azurerm_app_service" "proxybenefitsengine" {
##   name                = "${local.regioncodeprefix}proxybenefitsengine${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxies.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0"                 # http://jira.ehr.com/browse/PEX-2591
##     health_check_path           = "/api/appstatus/alive" # PEX-3137 - Enable AppSvc Health Check, PEX-5649
##     http2_enabled               = "true"                 # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
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

## Decommissioning Resource: [proxypensionaccess]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context
## # Proxy Pension Access App Service - http://jira.ehr.com/browse/PEX-1445
## resource "azurerm_app_service" "proxypensionaccess" {
##   name                = "${local.regioncodeprefix}proxypensionaccess${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxies.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0"         # http://jira.ehr.com/browse/PEX-2591
##     health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled               = "true"         # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
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

## Decommissioning Resource: [proxyeepoint]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context
## # Proxy EEPoint App Service - http://jira.ehr.com/browse/PEX-1550
## resource "azurerm_app_service" "proxyeepoint" {
##   name                = "${local.regioncodeprefix}proxyeepoint${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxies.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0"             # http://jira.ehr.com/browse/PEX-2591
##     health_check_path           = "/eepoint/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled               = "true"             # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
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

## Decommissioning Resource: [proxyees]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context

## resource "azurerm_app_service" "proxyees" {
##   name                = "${local.regioncodeprefix}proxyees${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxies.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0"     # http://jira.ehr.com/browse/PEX-2591
##     health_check_path           = "/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled               = "true"     # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
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

# # Proxy Benefits Access App Service - http://jira.ehr.com/browse/PEX-2100
# resource "azurerm_app_service" "proxybenefitsaccess" {
#   name                = "${local.regioncodeprefix}proxybenefitsaccess${var.env_code}appsvc"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   app_service_plan_id = azurerm_app_service_plan.proxiesba.id
#   https_only          = "true" # force https
#   tags                = local.sa_tags
#   identity {
#     type = "SystemAssigned"
#   }
#   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
#   site_config {
#     always_on                   = "true"
#     scm_use_main_ip_restriction = "true"
#     dotnet_framework_version    = "v6.0"         # http://jira.ehr.com/browse/PEX-2591
#     health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
#     http2_enabled               = "true"         # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
#   }
#   # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
#   # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
#   lifecycle {
#     ignore_changes = [
#       site_config["scm_type"]
#     ]
#   }
# }
# end

## Decommissioning Resource: [proxyregistration]
## Reason: PEX-8742 As part of the optimization efforts made by the Embark Standard team, we 
## should now be able to stop and eventually delete the proxy services except for Benefits Access
## Related Jira Ticket: https://jira.ehr.com/browse/PEX-8983
## Date of Decommissioning: mm/dd/yyyy
## Note: This resource is being commented out as part of the decommissioning process.
## If restoration is needed, please refer to the Jira ticket for context

## # https://jira.ehr.com/browse/PEX-6215 - [DevOps] Create pipeline and App service for WTW.EX.Integration.Proxies > WTW.EX.Proxy.Registration Project
## resource "azurerm_app_service" "proxyregistration" {
##   name                = "${local.regioncodeprefix}proxyregistration${var.env_code}appsvc"
##   location            = var.location
##   resource_group_name = var.resource_group_name
##   app_service_plan_id = azurerm_app_service_plan.proxies.id
##   https_only          = "true" # force https
##   tags                = local.sa_tags
##   identity {
##     type = "SystemAssigned"
##   }
##   # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
##   site_config {
##     always_on                   = "true"
##     scm_use_main_ip_restriction = "true"
##     dotnet_framework_version    = "v6.0"         # PEX-2591 - DevOps - Upgrade AppEx App Services to .NET 6
##     health_check_path           = "/api/isalive" # PEX-3137 - Enable AppSvc Health Check
##     http2_enabled               = "true"         # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
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
