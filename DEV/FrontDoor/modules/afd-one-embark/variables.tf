variable "afd_profile_id" {
  description = "Profile ID"
  type = string
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
  default = false
}

variable "enable_primary_region" {
  description = "Enable Primary Region"
  type = bool
  default = true
}

variable "env_name" {
  description = "Environment Name"
  type = string
}

variable "host_names" {
  description = "Host Names"
  type = list(string)
}

variable "k8s_dr_private_link_id" {
  description = "K8s DR Private Link ID"
  type = string
}

variable "k8s_dr_region" {
  description = "K8s DR Region"
  type = string
}

variable "k8s_private_link_id" {
  description = "K8s Private Link ID"
  type = string
}

variable "k8s_region" {
  description = "K8s Region"
  type = string
}

variable "keyvault_name" {
  description = "Key Vault Name (ex: n20doabdrnonprodkv)"
  type = string
}

variable "primary_host_name" {
  description = "Main URL for the site (ex: devint.embark.ehr.com)"
  type = string
}