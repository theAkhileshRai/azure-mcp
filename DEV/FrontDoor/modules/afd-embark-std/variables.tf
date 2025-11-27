variable "afd_profile_id" {
  description = "Profile ID"
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
}

variable "env_name" {
  description = "Environment Name"
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

variable "keyvault_name" {
  description = "Key Vault Name (ex: n20doabdrnonprodkv)"
}

variable "csp_header_assetsblob_microfrontendcdn" {
  description = "CSP Header Asssets Blob and Microfrontend CDN"
}

variable "csp_header_microfrontendcdn" {
  description = "CSP Header Microfrontend CDN"
}

variable "csp_header_assetsblob" {
  description = "CSP Header Assets Blob"
}

variable "csp_header_assetscdn_domain" {
  description = "CSP Header Assets CDN Domain"
}

variable "csp_header_microfrontendcdn_domain" {
  description = "CSP Header Microfrontend CDN Domain"
}

variable "csp_header_embarkstd_domain" {
  description = "CSP Header Embark Standard Domain"
}

variable "csp_header_localhost" {
  description = "CSP Header Localhost"
  default = ""
}

variable "permissions_policy_value" {
  description = "Permissions Policy Value"
}