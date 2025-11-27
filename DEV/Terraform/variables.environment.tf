## Start - Pipeline Managed variables

variable "app_service_plan_capacity_gateway" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_infocenter" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_microfrontend" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_proxies" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_proxiesba" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_proxiesaux" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_queue" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_registration" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_uiguide" {
  description = "value"
  default     = ""
}

variable "app_service_plan_capacity_widgetsaux" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_gateway" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_infocenter" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_microfrontend" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_proxies" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_proxiesba" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_proxiesaux" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_queue" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_registration" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_uiguide" {
  description = "value"
  default     = ""
}

variable "app_service_plan_size_widgetsaux" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_gateway" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_infocenter" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_microfrontend" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_proxies" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_proxiesba" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_proxiesaux" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_queue" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_registration" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_uiguide" {
  description = "value"
  default     = ""
}

variable "app_service_plan_tier_widgetsaux" {
  description = "value"
  default     = ""
}

## End - Pipeline Managed variables

variable "appsvcVNET" {
  description = "VNET reference. AGW should be in Terraform-scripts=/Scripts/agw/vnets_in_use.txt"
  default     = ""
}

variable "atmTargetResourceID" {
  description = "Azure Traffic Manager Resource ID"
  default     = ""
}

variable "agw_name" {
  description = "Environment Code"
  default     = ""
}

variable "agw_capacity" {
  description = "Environment Code"
  default     = ""
}

variable "dnn_stg_conn_string" {
  description = "Environment Code"
  default     = ""
}

variable "dnn_stg_conn_string_google" {
  description = "DNN Storage Account Connection String for Google Console Admin"
  default     = ""
}

variable "env_code" {
  description = "value"
  default     = ""
}


variable "cdn_sku" {
  description = "Environment Code"
  default     = ""
}

variable "gatewayhostname" {
  description = "value"
  default     = ""
}


variable "ees_iap" {
  description = "Environment Code"
  default     = ""
}

variable "ees_insight" {
  description = "Environment Code"
  default     = ""
}

variable "keyvault" {
  description = "value"
  default     = ""
}

variable "keyvault_certificate_name" {
  description = "value"
  default     = ""
}


variable "keyvault_resourcegroup" {
  description = "value"
  default     = ""
}

variable "location" {
  description = "value"
  default     = ""
}

variable "loganalytics_workspace" {
  description = "value"
  default     = ""
}

variable "loganalytics_resourcegroup" {
  description = "value"
  default     = ""
}

variable "region" {
  description = "value"
  default     = ""
}

variable "region_code" {
  description = "value"
  default     = ""
}

variable "regiondr" {
  description = "Environment Code"
  default     = ""
}

variable "registration_fqdn" {
  description = "value"
  default     = ""
}

variable "registrationhostname" {
  description = "value"
  default     = ""
}

variable "resource_group_location" {
  description = "value"
  default     = ""
}

variable "resource_group_name" {
  description = "value"
  default     = ""
}

variable "resourcegroupnameFailover" {
  description = "value"
  default     = ""
}

variable "resourcegroupnamePrimary" {
  description = "value"
  default     = ""
}

variable "resourceNamePrimary" {
  description = "value"
  default     = ""
}

variable "servicebus_namespace" {
  description = "value"
  default     = ""
}

variable "servicebus_sku" {
  description = "value"
  default     = ""
}

variable "sql_version" {
  description = "Environment Code"
  default     = "12.0"
}

variable "sql_collation" {
  description = "Environment Code"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "sql_edition" {
  description = "Environment Code"
  default     = "Standard"
}

variable "sql_max_size_bytes" {
  description = "Environment Code"
  default     = ""
}

variable "sql_requested_service_objective_name" {
  description = "Environment Code"
  default     = ""
}

variable "sql_requested_service_objective_name_configuration" {
  description = "Environment Code"
  default     = ""
}

variable "sql_administrator_login" {
  description = "value"
  default     = ""
}

variable "sql_administrator_login_password" { # VAULT
  description = "value"
  default     = ""
}

variable "storage_projectexdnn_blob_endpoint" {
  description = "value"
  default     = ""
}

variable "storage_projectexdnn_web_endpoint" {
  description = "value"
  default     = ""
}

variable "storage_tier" {
  description = "value"
  default     = ""
}

variable "storage_replication_type" {
  description = "value"
  default     = ""
}

variable "storage_replication_type_dnn" {
  description = "value"
  default     = ""
}

variable "waf_policy_name" {
  description = "value"
  default     = ""
}

variable "signalr_sku_name" {
  description = "SignalR SKU name/tier"
  default     = ""
}

variable "signalr_sku_capacity" {
  description = "SignalR SKU capacity"
  default     = ""
}

variable "mdcalert_connection_id" {
  description = "Microsoft Defender for Cloud Alert Connection ID"
  default     = ""
}

variable "mdcalert_connection_name" {
  description = "Microsoft Defender for Cloud Alert Connection Name"
  default     = ""
}

variable "mdcalert_id" {
  description = "Microsoft Defender for Cloud Alert ID"
  default     = ""
}

# AD Group Object IDs

variable "singleauthappinsights_adgroup_objectid" {
  description = "Single Auth App Insights AD group"
  default = ""
}

# Service Principal Object IDs

variable "hbcloudgovernance_serviceprincipal_objectid" {
  description = "HB Cloud Governance Service Principal"
  default = ""
}