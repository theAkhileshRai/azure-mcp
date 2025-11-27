variable "agw_monitor_probe_b2cext" {
  description = "B2C Extensions Uri path for health probing"
  default     = "/api/isalive"
}

variable "agw_monitor_probe_cltadmin" {
  description = "Client Admin Uri path for health probing"
  default     = "/"
}

variable "agw_monitor_probe_rootconfigmicrofrontend" {
  description = "Root Config Uri path for health probing"
  default     = "/"
}

variable "agw_monitor_probe_samltest" {
  description = "SAML Test Uri path for health probing"
  default     = "/"
}

variable "agw_monitor_probe_frontui" {
  description = "Front UI Uri path for health probing"
  default     = "/"
}

variable "agw_monitor_probe_gateway" {
  description = "Gateway Uri path for health probing"
  default     = "/api/registrationConfig/ManageClients/GetClientCountryByURL?urlName=admin"
}

variable "agw_monitor_probe_registration" {
  description = "Registration UI Uri path for health probing"
  default     = "/"
}

variable "app_name" {
  description = "Environment Code"
  default     = "appx"
}

variable "AppID" {
  description = "Azure Tag"
  default     = "000630"
}

variable "SAAppID" {
  description = "Azure Tag"
  default     = "005745"
}

variable "business" {
  description = "Azure Tag"
  default     = "hwc"
}

variable "hostdomain" {
  description = "DNS EHR"
  default     = "ehr.com"
}

variable "hostdomain_towerswatson" {
  description = "DNS Towers Watson"
  default     = "towerswatson.com"
}

variable "hostdomain_willistowerswatson" {
  description = "DNS Willis Towers Watson"
  default     = "willistowerswatson.com"
}

variable "hostingprovider" {
  description = "Hosting Provider"
  default     = "azure"
}

variable "iac_tag" {
  description = "Azure Tag"
  # default     = "Pipelines: ProjectEX-IaC-YAML"
  default = "Release: ProjectEX-IaC"
}

variable "product" {
  description = "Azure Tag"
  default     = "embark"
}

variable "SAproduct" {
  description = "Azure Tag"
  default     = "singleauth"
}

variable "productgroupcode" {
  description = "Environment Code"
  default     = "pex"
}

variable "program" {
  description = "Product Tagging"
  default     = "embarkstandard"
}

variable "SAprogram" {
  description = "Product Tagging"
  default     = "singleauth"
}

variable "projectname" {
  description = "Environment Code"
  default     = "projectex"
}
