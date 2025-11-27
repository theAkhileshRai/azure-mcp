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

variable "load_balancer_name" {
  description = "Load Balancer Name"
}

variable "subscription_id" {
  description = "Subscription ID"
}

variable "vm_ip_info" {
  description = "IP info of VMs"
  type = object({
    nic_id         = string,
    ip_config_name = string
  })
}

variable "vm_resource_group_name" {
  description = "VM Resource Group Name"
}

variable "vnet_name" {
  description = "VNet Name"
}

variable "vnet_resource_group_name" {
  description = "VNet Resource Group Name"
}

variable "vnet_subnet_name" {
  description = "Subnet Name"
}