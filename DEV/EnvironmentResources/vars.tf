variable "appconfigname" {
  description = "App Config Name"
}
variable "appname" {
  description = "name of the app"
}
variable "AppID" {
  description = "AppID"
  default     = "000529"
}
variable "aadgroup_object_id" {
  description = "The object Id of the Embark Development team from Microsoft Entra ID Group: TROP-Developers-PTL"
  default     = "b2c0a04d-4b57-4b2c-981e-579f993dc6a0"
}
variable "azdo_pipeline_contributor_id" {
  description = "The Object ID of the Azure DevOps Pipeline Contributor"
}
variable "bedrock_dr_ip" {
  description = "Bedrock DR IP"
}
variable "bedrock_subnet_ids" {
  description = "Bedrock Subnet IDs"
}
variable "envCode" {
  description = "Environment Code"
}
variable "IACTag" {
  description = "Name for IAC Pipeline"
}
variable "issuer_url" {
  description = "URL for issuer"
}
variable "issuer_failover_url" {
  description = "URL for issuer"
}
variable "keyvault" {
  description = "Key Vault Name"
}
variable "k8s_managed_id" {
  description = "K8s Managed ID"
}
variable "location" {
  description = "Location"
}
variable "namespace" {
  description = "Namespace"
}
variable "redis_cache_capacity" {
  description = "Redis Capacity"
}
variable "redis_cache_family" {
  description = "Redis Family"
}
variable "redis_cache_name" {
  description = "Redis Name"
}
variable "redis_cache_sku" {
  description = "Redis SKU"
}
variable "regionCode" {
  description = "Region code"
}
variable "resource_group_name" {
  description = "Resource Group Name"
}
variable "service_bus_authrule" {
  description = "Service Bus Auth Rule"
}
variable "service_bus_name" {
  description = "Service Bus Name"
}
variable "service_bus_topicname" {
  description = "Service Bus Topic Name"
}
variable "sql_administrator_login_password" {
  description = "SQL Admin Password"
}
variable "sql_admin_group_name" {
  description = "SQL Admin Group Name"
}
variable "sql_admin_group_object_id" {
  description = "Object ID for SQL Admin Group"
}
variable "sql_elastic_pool_name" {
  description = "Pool Name"
}
variable "sql_max_size_gb_integer" {
  description = "Max DB Size"
}
variable "sql_min_capacity_integer" {
  description = "Min DB Size"
}
variable "sql_server_name" {
  description = "Name of the SQL Server"
}
variable "sql_sku_capacity" {
  description = "Capacity"
}
variable "sql_sku_name" {
  description = "Sku"
}
variable "sql_sku_tier" {
  description = "Tier"
}
variable "sql_zone_redundant_bool" {
  description = "Is Redundant"
}
variable "sql_license_type" {
  description = "License Type of the SQL Elastic Pool"
}
variable "sql_azuread_authentication_only" {
  description = "Specifies whether only AD Users and administrators can be used to login, or also local database users"
  default     = false
}
variable "appcfg_privateendpoint_name" {
  description = "App Config Private endpoint Name"
}
variable "private_endpoint_subnet_id" {
  description = "App Config & Redis Private endpoint subnet id"
}
variable "public_access" {
  description = "App Config Public network access"
}
variable "redis_cache_privateendpoint_name" {
  description = "Redis Cache Private endpoint Name"
}
variable "redis_public_access" {
  description = "Redis Cache Public network access"
  default     = true
}
variable "appconfig_local_auth_enabled" {
  description = "App Config local authentication methods enabled"
}
variable "nonprod_env" {
  description = "Used to determine if the resource will be deployed in a nonprod env, i.e. for granting permissions to developers."
}
variable "embark_asb_dataowner" {
  description = "AD Group that will be ASB Data Owner"
}
variable "oneembark_sqlpswd" {
  description = "name of the secret where sql pswd is generated"
}
variable "k8s_public_ip" {
  description = "K8s Public IP"
}
variable "k8s_failover_public_ip" {
  description = "K8s Public IP in DR Region"
}
variable "enclave_type" {
  description = "Enclave Type for SQL Database"
  default     = "VBS" 
}