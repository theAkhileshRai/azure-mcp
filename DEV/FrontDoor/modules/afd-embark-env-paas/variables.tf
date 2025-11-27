variable "afd_profile_id" {
  description = "Profile ID"
}

variable "app_service_dr_name" {
  description = "DR App Service Name"
  type = string
  default = ""
}

variable "app_service_dr_resource_group_name" {
  description = "DR App Service Resource Group Name"
  type = string
  default = ""
}

variable "cdn_host_name" {
  description = "CDN Host Name"
}

variable "default_tags" {
  type = map(string)
  default = {
    AppID = "000529",
    IAC = "#{iac_tag}#"
  }
}

variable "enable_dr_region" {
  description = "Enable DR Region"
  type = bool
}

variable "enable_paas_dr_region" {
  description = "Enable PaaS DR Region"
  type = bool
  default = false
}

variable  "enable_paas_region" {
  description = "Enable Primary PaaS Region"
  type = bool
  default = true
}

variable "enable_primary_region" {
  description = "Enable Primary Region"
  type = bool
}

variable "env_name" {
  description = "Environment Name"
}

variable "dnn_region" {
  description = "DNN Region"
}

variable "host_name" {
  description = "Host Name"
}

variable "include_paas_dr_region" {
  description = "Include PaaS DR Region"
  type = bool
  default = false
}

variable "k8s_private_link_id" {
  description = "K8s Private Link ID"
}

variable "k8s_region" {
  description = "K8s Region"
}

variable "k8s_dr_private_link_id" {
  description = "K8s DR Private Link ID"
}

variable "k8s_dr_region" {
  description = "K8s DR Region"
}

variable "kb_host_name" {
  description = "Host Name of the KB site (ex: experience-kb-devint-ehr-com)"
}

variable "keyvault_name" {
  description = "Key Vault Name (ex: n20doabdrnonprodkv)"
}

variable "subscription_id" {
  description = "Subscription ID"
}

variable "app_service_resource_group_name" {
  description = "DNN Resource Group Name"
}

variable "app_service_name" {
  description = "VNet Name"
}
