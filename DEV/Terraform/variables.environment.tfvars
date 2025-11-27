### App Service Plan Variables
app_service_plan_capacity_gateway                    = 1
app_service_plan_capacity_infocenter                 = 1
app_service_plan_capacity_microfrontend              = 1
app_service_plan_capacity_proxies                    = 1
app_service_plan_capacity_proxiesaux                 = 1
app_service_plan_capacity_proxiesba                  = 1
app_service_plan_capacity_queue                      = 1
app_service_plan_capacity_registration               = 1
app_service_plan_capacity_uiguide                    = 1
app_service_plan_capacity_widgetsaux                 = 1
app_service_plan_size_gateway                        = "P1v3"
app_service_plan_size_infocenter                     = "S2"
app_service_plan_size_microfrontend                  = "S3"
app_service_plan_size_proxies                        = "P2v2"
app_service_plan_size_proxiesaux                     = "S3"
app_service_plan_size_proxiesba                      = "S2"
app_service_plan_size_queue                          = "S2"
app_service_plan_size_registration                   = "S3"
app_service_plan_size_uiguide                        = "S1"
app_service_plan_size_widgetsaux                     = "S3" 
app_service_plan_tier_gateway                        = "PremiumV3"
app_service_plan_tier_infocenter                     = "Standard"
app_service_plan_tier_microfrontend                  = "Standard"
app_service_plan_tier_proxies                        = "PremiumV2"
app_service_plan_tier_proxiesaux                     = "Standard"
app_service_plan_tier_proxiesba                      = "Standard"
app_service_plan_tier_queue                          = "Standard"
app_service_plan_tier_registration                   = "Standard"
app_service_plan_tier_uiguide                        = "Standard"
app_service_plan_tier_widgetsaux                     = "Standard"

## KeyVault-Referenced Variables
dnn_stg_conn_string              = "__dnn_stg_conn_string__"
sql_administrator_login_password = "__sql_administrator_login_password__"
appsvcVNET                       = "__appsvcVNET__"

## Cloud Resource referenced variables
agw_name                             = "n21appxdev-agw"
agw_capacity                         = 2
cdn_sku                              = "Standard_Microsoft"
env_code                             = "dev"
keyvault                             = "devops-hcbtro-dev-kv" # keyvault where certificate is stored. using keyvault from bedrock
keyvault_certificate_name            = "embark-dev-ehr-com"
keyvault_resourcegroup               = "devops-kv-rgrp"
location                             = "centralus"
loganalytics_workspace               = "n21-wtw-hcbtro-dev-logworkspace"
loganalytics_resourcegroup           = "n21-wtw-hcbtro-dev-loganalytics"
region_code                          = "n21"
region                               = "na"
regiondr                             = ""
resource_group_name                  = "n21-pex-dev-projectex-rgrpnew"
resource_group_location              = "centralus"
servicebus_sku                       = "Standard"
servicebus_namespace                 = "n21appxdevservicebus"
signalr_sku_capacity                 = "1"
signalr_sku_name                     = "Standard_S1"
sql_administrator_login              = "dbadmin"
sql_collation                        = "SQL_Latin1_General_CP1_CI_AS"
sql_edition                          = "Standard"
sql_max_size_bytes                   = "53687091200"
sql_requested_service_objective_name = "S1"
sql_requested_service_objective_name_configuration = "S3"
sql_version                          = "12.0"
storage_projectexdnn_blob_endpoint   = "n21projectexdnndevstg.blob.core.windows.net"
storage_projectexdnn_web_endpoint    = "n21projectexdnndevstg.z19.web.core.windows.net"
storage_tier                         = "Standard"
storage_replication_type             = "LRS"
waf_policy_name                      = ""

## Microsoft Defender for Cloud Storage Variables

mdcalert_connection_id               = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-pex-dev-projectex-rgrpnew/providers/Microsoft.Web/connections/mdcalert-Remove-MalwareBlob"
mdcalert_connection_name             = "mdcalert-Remove-MalwareBlob"
mdcalert_id                          = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/providers/Microsoft.Web/locations/centralus/managedApis/ascalert"

# AD Group variables

singleauthappinsights_adgroup_objectid = "cdd7adee-cb7c-4105-8d12-8c11dbb3784c"

# Service Principal variables

hbcloudgovernance_serviceprincipal_objectid = "e650346d-73cf-4958-b88c-914e9221c12f"