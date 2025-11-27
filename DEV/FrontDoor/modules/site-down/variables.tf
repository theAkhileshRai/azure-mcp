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

variable "dnn_region" {
  description = "DNN Region"
}

variable "app_service_resource_group_name" {
  description = "DNN Resource Group Name"
}

variable "app_service_name" {
  description = "VNet Name"
}
