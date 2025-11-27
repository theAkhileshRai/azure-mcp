locals {
  env_name            = "prod"
  frontdoor_name      = "${local.region_code}-ex-${var.app_name}-${local.env_name}-afd"
  kv_identity_name    = "devops-wtw-hcbtro-prod-kv-agwid"
  location            = "East US 2"
  log_analytics_name  = "${local.region_code}-ex-${var.app_name}-${local.env_name}-afd"
  region_code         = "n20"
  resource_group_name = "${local.region_code}-ex-${var.app_name}-${local.env_name}-afd-rg"
}

resource "azurerm_cdn_frontdoor_security_policy" "security-policy" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  name                     = "${local.frontdoor_name}-policy"
  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.policy.id
      association {
        patterns_to_match = ["/*"]
        domain {
          cdn_frontdoor_domain_id = module.afd-hrportal-uat.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-uat.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-uatemea.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-hrportal-prod.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-prodna.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-prodemea.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-embarkstd-uat.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-embarkstd-prod.domain_id
        }
      }
    }
  }

  depends_on = [
    module.afd-hrportal-uat,
    module.afd-experience-uat,
    module.afd-experience-uatemea,
    module.afd-hrportal-prod,
    module.afd-experience-prodna,
    module.afd-experience-prodemea,
    module.afd-embarkstd-uat,
    module.afd-embarkstd-prod
  ]
}

//hrportal-uat.ehr.com
module "private-link-uat" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW001U-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW001U-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-ptl-uat-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW001U-00" }
  vm_resource_group_name   = "n21-ptl-uat-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-uat2" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW002U-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW002U-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-ptl-uat-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW002U-00" }
  vm_resource_group_name   = "n21-ptl-uat-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-uat3" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW003U-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW003U-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-ptl-uat-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW003U-00" }
  vm_resource_group_name   = "n21-ptl-uat-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

# module "private-link-uat-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "East US2"
#   load_balancer_name       = "N21-TR-PTLW001U-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW001U-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-ptl-uat-embark-vm-rgrp-asr/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW001U-00" }
#   vm_resource_group_name   = "n21-ptl-uat-embark-vm-rgrp-asr"
#   vnet_name                = "hcbtro-private-n20-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-uat2-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "East US2"
#   load_balancer_name       = "N21-TR-PTLW002U-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW002U-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-ptl-uat-embark-vm-rgrp-asr/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW002U-00" }
#   vm_resource_group_name   = "n21-ptl-uat-embark-vm-rgrp-asr"
#   vnet_name                = "hcbtro-private-n20-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-uat3-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "East US2"
#   load_balancer_name       = "N21-TR-PTLW003U-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW003U-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-ptl-uat-embark-vm-rgrp-asr/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW003U-00" }
#   vm_resource_group_name   = "n21-ptl-uat-embark-vm-rgrp-asr"
#   vnet_name                = "hcbtro-private-n20-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }


module "afd-hrportal-uat" {
  source                 = "./modules/afd-embark-env"
  env_name               = "uat"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name          = "n21embarkuatcdnstg.z19.web.core.windows.net"
  default_tags           = var.default_tags
  dnn_region             = "Central US"
  host_name              = "hrportal-uat.ehr.com"
  k8s_private_link_id    = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  enable_primary_region  = true
  k8s_dr_private_link_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  enable_dr_region       = false
  kb_host_name           = "hrportal-kb-uat.ehr.com"
  keyvault_name          = "n20doabdrprodkv"
  private_link_ids = [
    { vm_name = "N21-TR-PTLW001U", private_link_id = module.private-link-uat.private_link_id },
    { vm_name = "N21-TR-PTLW002U", private_link_id = module.private-link-uat2.private_link_id },
    { vm_name = "N21-TR-PTLW003U", private_link_id = module.private-link-uat3.private_link_id },
    # { vm_name = "N21-TR-PTLW001U", private_link_id = module.private-link-uat-dr.private_link_id },
    # { vm_name = "N21-TR-PTLW002U", private_link_id = module.private-link-uat2-dr.private_link_id },
    # { vm_name = "N21-TR-PTLW003U", private_link_id = module.private-link-uat3-dr.private_link_id }
  ]
  search_boost_private_link_id = module.private-link-uat3.private_link_id
  #search_boost_private_link_id = module.private-link-uat3-dr.private_link_id
  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience100-uat.ehr.com
module "afd-experience-uat" {
  source                             = "./modules/afd-embark-env-paas"
  env_name                           = "uat-paas"
  afd_profile_id                     = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                      = "n21embarkuatcdnstg.z19.web.core.windows.net"
  default_tags                       = var.default_tags
  dnn_region                         = "Central US"
  host_name                          = "experience100-uat.ehr.com"
  k8s_private_link_id                = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                         = "Central US"
  enable_primary_region              = true
  k8s_dr_private_link_id             = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                      = "East US2"
  enable_dr_region                   = false
  kb_host_name                       = "experience100-kb-uat.ehr.com"
  keyvault_name                      = "n20doabdrprodkv"
  subscription_id                    = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  app_service_name                   = "n21hrportaluatappsvc"
  app_service_resource_group_name    = "n21-ptl-uat-hrportaldnn-rgrp"
  app_service_dr_name                = "n20hrportaluatappsvc"
  app_service_dr_resource_group_name = "n20-ptl-uat-hrportaldnn-rgrp"
  enable_paas_dr_region              = false
  enable_paas_region                 = true
  include_paas_dr_region             = true

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience200-uat.ehr.com
module "afd-experience-uatemea" {
  source                             = "./modules/afd-embark-env-paas"
  env_name                           = "uatemea-paas"
  afd_profile_id                     = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                      = "e21embarkuatcdnstg.z16.web.core.windows.net"
  default_tags                       = var.default_tags
  dnn_region                         = "North Europe"
  host_name                          = "experience200-uat.ehr.com"
  k8s_private_link_id                = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/e21-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                         = "North Europe"
  enable_primary_region              = true
  k8s_dr_private_link_id             = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/e20-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                      = "West Europe"
  enable_dr_region                   = false
  kb_host_name                       = "experience200-kb-uat.ehr.com"
  keyvault_name                      = "e20doabdrprodkv"
  subscription_id                    = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  app_service_name                   = "e21hrportaluatappsvc"
  app_service_resource_group_name    = "e21-ptl-uat-hrportaldnn-rgrp"
  # app_service_dr_name                = "e20hrportaluatappsvc"
  # app_service_dr_resource_group_name = "e20-ptl-uat-hrportaldnn-rgrp"
  # enable_paas_dr_region              = false
  # enable_paas_region                 = true
  # include_paas_dr_region             = true

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}






//hrportal.ehr.com
module "private-link-prod" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLW001P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW001P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW001P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-prod2" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLW002P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW002P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW002P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-prod3" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLW003P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW003P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW003P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-prod4" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLW004P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW004P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW004P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-prod5" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLW005P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW005P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW005P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-prod6" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLW006P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW006P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW006P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-prod7" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLW007P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW007P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW007P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-prod8" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLW008P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW008P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW008P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}



# # DISASTER RECOVERY SECTION
# module "private-link-prod-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLW001P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW001P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW001P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n2-asr-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-prod2-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLW002P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW002P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW002P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n21-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-prod3-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLW003P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW003P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW003P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n21-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-prod4-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLW004P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW004P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW004P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n21-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-prod5-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLW005P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW005P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW005P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n21-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-prod6-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLW006P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW006P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW006P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n21-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-prod7-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLW007P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW007P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW007P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n21-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-prod8-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLW008P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLW008P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLW008P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n21-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }

# module "private-link-prodjob-dr" {
#   source                   = "./modules/afd-embark-iaas-pls"
#   default_tags             = var.default_tags
#   dnn_region               = "Central US"
#   load_balancer_name       = "N20-TR-PTLJOB1P-lb"
#   subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
#   vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLJOB1P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLJOB1P-00" }
#   vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP-asr"
#   vnet_name                = "hcbtro-private-n21-vnet"
#   vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
#   vnet_subnet_name         = "dmz1"
# }
# END DISASTER RECOVERY SECTION

module "private-link-prodjob" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "East US2"
  load_balancer_name       = "N20-TR-PTLJOB1P-lb"
  subscription_id          = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  vm_ip_info               = { ip_config_name = "nic-N20-TR-PTLJOB1P-00-ipConfig", nic_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-ptl-prd-embark-vm-rgrp-temp/providers/Microsoft.Network/networkInterfaces/nic-N20-TR-PTLJOB1P-00" }
  vm_resource_group_name   = "N20-PTL-PRD-EMBARK-VM-RGRP-TEMP"
  vnet_name                = "hcbtro-private-n20-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "afd-hrportal-prod" {
  source                 = "./modules/afd-embark-env"
  env_name               = "prod"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name          = "n20embarkprdcdnstg.z20.web.core.windows.net"
  default_tags           = var.default_tags
  dnn_region             = "East US2"
  host_name              = "hrportal.ehr.com"
  k8s_private_link_id    = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "East US2"
  enable_primary_region  = true
  k8s_dr_private_link_id = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "Central US"
  enable_dr_region       = false
  kb_host_name           = "hrportal-kb.ehr.com"
  keyvault_name          = "n20doabdrprodkv"
  private_link_ids = [
    { vm_name = "N20-TR-PTLW001P", private_link_id = module.private-link-prod.private_link_id },
    { vm_name = "N20-TR-PTLW002P", private_link_id = module.private-link-prod2.private_link_id },
    { vm_name = "N20-TR-PTLW003P", private_link_id = module.private-link-prod3.private_link_id },
    { vm_name = "N20-TR-PTLW004P", private_link_id = module.private-link-prod4.private_link_id },
    { vm_name = "N20-TR-PTLW005P", private_link_id = module.private-link-prod5.private_link_id },
    { vm_name = "N20-TR-PTLW006P", private_link_id = module.private-link-prod6.private_link_id },
    { vm_name = "N20-TR-PTLW007P", private_link_id = module.private-link-prod7.private_link_id },
    { vm_name = "N20-TR-PTLW008P", private_link_id = module.private-link-prod8.private_link_id }

    # { vm_name = "N20-TR-PTLW001P", private_link_id = module.private-link-prod-dr.private_link_id },
    # { vm_name = "N20-TR-PTLW002P", private_link_id = module.private-link-prod2-asr.private_link_id },
    # { vm_name = "N20-TR-PTLW003P", private_link_id = module.private-link-prod3-asr.private_link_id },
    # { vm_name = "N20-TR-PTLW004P", private_link_id = module.private-link-prod4-asr.private_link_id },
    # { vm_name = "N20-TR-PTLW005P", private_link_id = module.private-link-prod5-asr.private_link_id }
    ## { vm_name = "N20-TR-PTLW006P", private_link_id = module.private-link-prod6-asr.private_link_id },
    ## { vm_name = "N20-TR-PTLW007P", private_link_id = module.private-link-prod7-asr.private_link_id },
    ## { vm_name = "N20-TR-PTLW008P", private_link_id = module.private-link-prod8-asr.private_link_id }
  ]
  search_boost_private_link_id = module.private-link-prodjob.private_link_id
  #search_boost_private_link_id = module.private-link-prodjob-dr.private_link_id
  depends_on                   = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience100.ehr.com
module "afd-experience-prodna" {
  source                             = "./modules/afd-embark-env-paas"
  env_name                           = "prodna-paas"
  afd_profile_id                     = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                      = "n20embarkprdcdnstg.z20.web.core.windows.net"
  default_tags                       = var.default_tags
  dnn_region                         = "East US2"
  host_name                          = "experience100.ehr.com"
  k8s_private_link_id                = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                         = "East US2"
  enable_primary_region              = true
  k8s_dr_private_link_id             = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                      = "Central US"
  enable_dr_region                   = false
  kb_host_name                       = "experience100-kb.ehr.com"
  keyvault_name                      = "n20doabdrprodkv"
  subscription_id                    = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  app_service_name                   = "n20hrportalprdappsvc"
  app_service_resource_group_name    = "n20-ptl-prd-hrportaldnn-rgrp"
  app_service_dr_name                = "n21hrportalprdappsvc"
  app_service_dr_resource_group_name = "n21-ptl-prd-hrportaldnn-rgrp"
  enable_paas_dr_region              = false
  enable_paas_region                 = true
  include_paas_dr_region             = true

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience200.ehr.com
module "afd-experience-prodemea" {
  source                             = "./modules/afd-embark-env-paas"
  env_name                           = "prodemea-paas"
  afd_profile_id                     = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                      = "e20embarkprdcdnstg.z6.web.core.windows.net"
  default_tags                       = var.default_tags
  dnn_region                         = "West Europe"
  host_name                          = "experience200.ehr.com"
  k8s_private_link_id                = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/e20-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                         = "West Europe"
  enable_primary_region              = true
  k8s_dr_private_link_id             = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/e21-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                      = "North Europe"
  enable_dr_region                   = false
  kb_host_name                       = "experience200-kb.ehr.com"
  keyvault_name                      = "e20doabdrprodkv"
  subscription_id                    = "f2447828-1080-40d5-9acf-e2a174c5b0bb"
  app_service_name                   = "e20hrportalprdappsvc"
  app_service_resource_group_name    = "e20-ptl-prd-hrportaldnn-rgrp"
  app_service_dr_name                = "e21hrportalprdappsvc"
  app_service_dr_resource_group_name = "e21-ptl-prd-hrportaldnn-rgrp"
  enable_paas_dr_region              = false
  enable_paas_region                 = true
  include_paas_dr_region             = true

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// OneEmbark - Embark Standard: UAT
module "afd-embarkstd-uat" {
  source                                 = "./modules/afd-embark-std"
  env_name                               = "uat"
  afd_profile_id                         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags                           = var.default_tags
  host_name                              = "embark-uat.ehr.com"
  k8s_private_link_id                    = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n21-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                             = "Central US"
  enable_primary_region                  = true
  k8s_dr_private_link_id                 = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/n20-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                          = "East US2"
  enable_dr_region                       = false
  keyvault_name                          = "n20doabdrprodkv"
  csp_header_assetsblob_microfrontendcdn = "https://n21projectexdnnuatstg.blob.core.windows.net/ https://n21microfrontenduatstgsitecdn.azureedge.net/"
  csp_header_microfrontendcdn            = "https://n21microfrontenduatstgsitecdn.azureedge.net/"
  csp_header_assetsblob                  = "https://n21projectexdnnuatstg.blob.core.windows.net/assets/"
  csp_header_embarkstd_domain            = "embark-uat.ehr.com"
  csp_header_assetscdn_domain            = "https://assets-embark-uat.ehr.com/"
  csp_header_microfrontendcdn_domain     = "https://microfrontend-embark-uat.ehr.com/"
  permissions_policy_value               = "accelerometer=(),camera=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()"
  depends_on                             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// OneEmbark - Embark Standard: Prod
module "afd-embarkstd-prod" {
  source                                 = "./modules/afd-embark-std"
  env_name                               = "prod"
  afd_profile_id                         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags                           = var.default_tags
  host_name                              = "embark.ehr.com"
  k8s_private_link_id                    = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/e20-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                             = "West Europe"
  enable_primary_region                  = true
  k8s_dr_private_link_id                 = "/subscriptions/f2447828-1080-40d5-9acf-e2a174c5b0bb/resourceGroups/e21-doa-bdr-prod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                          = "North Europe"
  enable_dr_region                       = false
  keyvault_name                          = "n20doabdrprodkv"
  csp_header_assetsblob_microfrontendcdn = "https://e20projectexdnnprdstg.blob.core.windows.net/ https://e20microfrontendprdstgsitecdn.azureedge.net/"
  csp_header_microfrontendcdn            = "https://e20microfrontendprdstgsitecdn.azureedge.net/"
  csp_header_assetsblob                  = "https://e20projectexdnnprdstg.blob.core.windows.net/assets/"
  csp_header_embarkstd_domain            = "embark.ehr.com"
  csp_header_assetscdn_domain            = "https://assets-embark.ehr.com/"
  csp_header_microfrontendcdn_domain     = "https://microfrontend-embark.ehr.com/"
  permissions_policy_value               = "accelerometer=(),camera=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()"
  depends_on                             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

module "site-down-dev" {
  source                          = "./modules/site-down"
  afd_profile_id                  = azurerm_cdn_frontdoor_profile.profile.id
  dnn_region                      = "East US 2"
  app_service_resource_group_name = "WTW-TR-DEVOPS-RGRP"
  app_service_name                = "dvositedown"
}
