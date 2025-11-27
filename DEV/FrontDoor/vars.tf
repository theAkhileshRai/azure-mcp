variable "app_code" {
  description = "Short app code"
  default     = "ptl"
}

variable "app_name" {
  description = "App name"
  default     = "hrportal"
}

variable "default_tags" {
  type = map(string)
  default = {
    AppID = "000529",
    IAC = "#{IACTag}#"
  }
}

variable "frontdoor_waf_mode" {
  description = "FrontDoor WAF mode"
  default     = "Prevention"
}

variable "frontdoor_waf_mode_oneembark" {
  description = "FrontDoor WAF mode for OneEmbark"
  default     = "Prevention"
}

variable "cdn_contributor_spn" {
  description = "CDN Profile Contributor Service Principal"
}