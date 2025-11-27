variable "afd_profile_id" {
  description = "Profile ID"
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
  description = "Host Name of the KB site (ex: hrportal-kb-devint-ehr-com)"
}

variable "keyvault_name" {
  description = "Key Vault Name (ex: n20doabdrnonprodkv)"
}

variable "private_link_id" {
  description = "Private Link ID"
}