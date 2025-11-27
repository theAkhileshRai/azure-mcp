locals {
  env_name            = "nonprod"
  frontdoor_name      = "${local.region_code}-ex-${var.app_name}-${local.env_name}-afd"
  kv_identity_name    = "devops-wtw-hcbtro-dev-kv-agwid"
  location            = "Central US"
  log_analytics_name  = "${local.region_code}-ex-${var.app_name}-${local.env_name}-afd"
  region_code         = "n21"
  resource_group_name = "${local.region_code}-ex-${var.app_name}-${local.env_name}-afd-rg"
}

//Make sure all domains are linked here
resource "azurerm_cdn_frontdoor_security_policy" "security-policy" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  name                     = "${local.frontdoor_name}-policy"
  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.policy.id
      association {
        patterns_to_match = ["/*"]
        domain {
          cdn_frontdoor_domain_id = module.afd-hrportal-devint.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-hrportal-qa.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-devint.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-hrportal-rt.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-hrportal-prodqa.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-qa.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-rt.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-lpt.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-experience-pqa.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-hrportal-st.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-hrportal-stdev.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-embarkstd-dev.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-embarkstd-devint.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.afd-embarkstd-qa.domain_id
        }
      }
    }
  }

  depends_on = [
    module.afd-hrportal-devint,
    module.afd-hrportal-qa,
    module.afd-experience-devint,
    module.afd-hrportal-rt,
    module.afd-hrportal-prodqa,
    module.afd-experience-qa,
    module.afd-experience-rt,
    module.afd-experience-lpt,
    module.afd-experience-pqa,
    module.afd-hrportal-st,
    module.afd-hrportal-stdev,
    module.afd-embarkstd-dev,
    module.afd-embarkstd-devint,
    module.afd-embarkstd-qa
  ]
}

//hrportal-devint.ehr.com
module "private-link-devint" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW001D-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW001D-00-ipConfig", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-devint-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW001D-00" }
  vm_resource_group_name   = "n21-ptl-devint-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-devint2" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW002D-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW002D-00-ipConfig", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-devint-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW002D-00" }
  vm_resource_group_name   = "n21-ptl-devint-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "afd-hrportal-devint" {
  source                 = "./modules/afd-embark-env"
  env_name               = "devint"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name          = "n21embarkdevcdnstg.z19.web.core.windows.net"
  default_tags           = var.default_tags
  dnn_region             = "Central US"
  host_name              = "hrportal-devint.ehr.com"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  enable_primary_region  = true
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  enable_dr_region       = false
  kb_host_name           = "hrportal-kb-devint.ehr.com"
  keyvault_name          = "n20doabdrnonprodkv"
  private_link_ids = [
    { vm_name = "n21-tr-ptlw001d", private_link_id = module.private-link-devint.private_link_id },
    { vm_name = "n21-tr-ptlw002d", private_link_id = module.private-link-devint2.private_link_id }
  ]
  search_boost_private_link_id = module.private-link-devint2.private_link_id
  depends_on                   = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// QA, RT, ProdQA Private Link
module "private-link-qa-rt-prodqa" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "n21-tr-ptlw101q-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "privateip1", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-nonprd-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/n21-tr-ptlw101q-private-nic-01" }
  vm_resource_group_name   = "n21-ptl-nonprd-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-qa-rt-prodqa2" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "n21-tr-ptlw102q-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "privateip1", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-nonprd-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/n21-tr-ptlw102q-private-nic-01" }
  vm_resource_group_name   = "n21-ptl-nonprd-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

//hrportal-qa.ehr.com
module "afd-hrportal-qa" {
  source                 = "./modules/afd-embark-env"
  env_name               = "qa"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name          = "n21embarkqacdnstg.z19.web.core.windows.net"
  default_tags           = var.default_tags
  dnn_region             = "Central US"
  host_name              = "hrportal-qa.ehr.com"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  enable_primary_region  = true
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  enable_dr_region       = true
  kb_host_name           = "hrportal-kb-qa.ehr.com"
  keyvault_name          = "n20doabdrnonprodkv"
  private_link_ids = [
    { vm_name = "n21-tr-ptlw101q", private_link_id = module.private-link-qa-rt-prodqa.private_link_id },
    { vm_name = "n21-tr-ptlw102q", private_link_id = module.private-link-qa-rt-prodqa2.private_link_id }
  ]
  search_boost_private_link_id = module.private-link-qa-rt-prodqa2.private_link_id
  depends_on                   = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//hrportal-rt.ehr.com
module "afd-hrportal-rt" {
  source                 = "./modules/afd-embark-env"
  env_name               = "rt"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name          = "n21embarkrtcdnstg.z19.web.core.windows.net"
  default_tags           = var.default_tags
  dnn_region             = "Central US"
  host_name              = "hrportal-rt.ehr.com"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  enable_primary_region  = true
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  enable_dr_region       = true
  kb_host_name           = "hrportal-kb-rt.ehr.com"
  keyvault_name          = "n20doabdrnonprodkv"
  private_link_ids = [
    { vm_name = "n21-tr-ptlw101q", private_link_id = module.private-link-qa-rt-prodqa.private_link_id },
    { vm_name = "n21-tr-ptlw102q", private_link_id = module.private-link-qa-rt-prodqa2.private_link_id }
  ]
  search_boost_private_link_id = module.private-link-qa-rt-prodqa2.private_link_id
  depends_on                   = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//hrportal-prodqa.ehr.com
module "afd-hrportal-prodqa" {
  source                 = "./modules/afd-embark-env"
  env_name               = "prodqa"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name          = "n21embarkpqacdnstg.z19.web.core.windows.net"
  default_tags           = var.default_tags
  dnn_region             = "Central US"
  host_name              = "hrportal-prodqa.ehr.com"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  enable_primary_region  = true
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  enable_dr_region       = true
  kb_host_name           = "hrportal-kb-prodqa.ehr.com"
  keyvault_name          = "n20doabdrnonprodkv"
  private_link_ids = [
    { vm_name = "n21-tr-ptlw101q", private_link_id = module.private-link-qa-rt-prodqa.private_link_id },
    { vm_name = "n21-tr-ptlw102q", private_link_id = module.private-link-qa-rt-prodqa2.private_link_id }
  ]
  search_boost_private_link_id = module.private-link-qa-rt-prodqa2.private_link_id
  depends_on                   = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//StressTest and StressTestDev Private Link
module "private-link-st" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW001L-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW001L-00-ipConfig", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-stresstest-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW001L-00" }
  vm_resource_group_name   = "n21-ptl-stresstest-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-st2" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW002L-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "nic-N21-TR-PTLW002L-00-ipConfig", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-stresstest-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/nic-N21-TR-PTLW002L-00" }
  vm_resource_group_name   = "n21-ptl-stresstest-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-st3" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW003L-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "ipconfig1", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-stresstest-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/n21-tr-ptlw003l45" }
  vm_resource_group_name   = "n21-ptl-stresstest-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-st4" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW004L-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "ipconfig1", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-stresstest-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/n21-tr-ptlw004l38" }
  vm_resource_group_name   = "n21-ptl-stresstest-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-st5" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW005L-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "ipconfig1", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-stresstest-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/n21-tr-ptlw005l58" }
  vm_resource_group_name   = "n21-ptl-stresstest-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "private-link-st6" {
  source                   = "./modules/afd-embark-iaas-pls"
  default_tags             = var.default_tags
  dnn_region               = "Central US"
  load_balancer_name       = "N21-TR-PTLW006L-lb"
  subscription_id          = "e643c042-3710-417e-9e59-27c45e2d46c3"
  vm_ip_info               = { ip_config_name = "ipconfig1", nic_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-ptl-stresstest-embark-vm-rgrp/providers/Microsoft.Network/networkInterfaces/n21-tr-ptlw006l604" }
  vm_resource_group_name   = "n21-ptl-stresstest-embark-vm-rgrp"
  vnet_name                = "hcbtro-private-n21-vnet"
  vnet_resource_group_name = "hcbtro-privatenetworks-rgrp"
  vnet_subnet_name         = "dmz1"
}

module "afd-hrportal-st" {
  source                 = "./modules/afd-embark-env"
  env_name               = "st"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name          = "n21embarklptcdnstg.z19.web.core.windows.net"
  default_tags           = var.default_tags
  dnn_region             = "Central US"
  host_name              = "hrportal-stresstest.ehr.com"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  enable_primary_region  = true
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  enable_dr_region       = true
  kb_host_name           = "hrportal-kb-stresstest.ehr.com"
  keyvault_name          = "n20doabdrnonprodkv"
  private_link_ids = [
    { vm_name = "n21-tr-ptlw001l", private_link_id = module.private-link-st.private_link_id },
    { vm_name = "n21-tr-ptlw002l", private_link_id = module.private-link-st2.private_link_id },
    { vm_name = "n21-tr-ptlw003l", private_link_id = module.private-link-st3.private_link_id },
    { vm_name = "n21-tr-ptlw004l", private_link_id = module.private-link-st4.private_link_id },
    { vm_name = "n21-tr-ptlw005l", private_link_id = module.private-link-st5.private_link_id }
  ]
  search_boost_private_link_id = module.private-link-st6.private_link_id
  depends_on                   = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

module "afd-hrportal-stdev" {
  source                 = "./modules/afd-embark-env"
  env_name               = "stdev"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name          = "n21embarklptcdnstg.z19.web.core.windows.net"
  default_tags           = var.default_tags
  dnn_region             = "Central US"
  host_name              = "hrportal-stresstestdev.ehr.com"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  enable_primary_region  = true
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  enable_dr_region       = true
  kb_host_name           = "hrportal-kb-stresstestdev.ehr.com"
  keyvault_name          = "n20doabdrnonprodkv"
  private_link_ids = [
    { vm_name = "n21-tr-ptlw001l", private_link_id = module.private-link-st.private_link_id },
    { vm_name = "n21-tr-ptlw002l", private_link_id = module.private-link-st2.private_link_id },
    { vm_name = "n21-tr-ptlw003l", private_link_id = module.private-link-st3.private_link_id },
    { vm_name = "n21-tr-ptlw004l", private_link_id = module.private-link-st4.private_link_id },
    { vm_name = "n21-tr-ptlw005l", private_link_id = module.private-link-st5.private_link_id }
  ]
  search_boost_private_link_id = module.private-link-st6.private_link_id
  depends_on                   = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience-devint.ehr.com
module "afd-experience-devint" {
  source                          = "./modules/afd-embark-env-paas"
  env_name                        = "devint-paas"
  afd_profile_id                  = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                   = "n21embarkdevcdnstg.z19.web.core.windows.net"
  default_tags                    = var.default_tags
  dnn_region                      = "Central US"
  host_name                       = "experience-devint.ehr.com"
  k8s_private_link_id             = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                      = "Central US"
  enable_primary_region           = true
  k8s_dr_private_link_id          = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                   = "East US2"
  enable_dr_region                = true
  kb_host_name                    = "experience-kb-devint.ehr.com"
  keyvault_name                   = "n20doabdrnonprodkv"
  subscription_id                 = "e643c042-3710-417e-9e59-27c45e2d46c3"
  app_service_name                = "n21hrportaldevappsvc"
  app_service_resource_group_name = "n21-ptl-dev-hrportaldnn-rgrp"

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience-qa.ehr.com
module "afd-experience-qa" {
  source                          = "./modules/afd-embark-env-paas"
  env_name                        = "qa-paas"
  afd_profile_id                  = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                   = "n21embarkqacdnstg.z19.web.core.windows.net"
  default_tags                    = var.default_tags
  dnn_region                      = "Central US"
  host_name                       = "experience-qa.ehr.com"
  k8s_private_link_id             = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                      = "Central US"
  enable_primary_region           = true
  k8s_dr_private_link_id          = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                   = "East US2"
  enable_dr_region                = true
  kb_host_name                    = "experience-kb-qa.ehr.com"
  keyvault_name                   = "n20doabdrnonprodkv"
  subscription_id                 = "e643c042-3710-417e-9e59-27c45e2d46c3"
  app_service_name                = "n21hrportalqaappsvc"
  app_service_resource_group_name = "n21-ptl-qa-hrportaldnn-rgrp"

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience-rt.ehr.com
module "afd-experience-rt" {
  source                          = "./modules/afd-embark-env-paas"
  env_name                        = "rt-paas"
  afd_profile_id                  = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                   = "n21embarkrtcdnstg.z19.web.core.windows.net"
  default_tags                    = var.default_tags
  dnn_region                      = "Central US"
  host_name                       = "experience-rt.ehr.com"
  k8s_private_link_id             = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                      = "Central US"
  enable_primary_region           = true
  k8s_dr_private_link_id          = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                   = "East US2"
  enable_dr_region                = true
  kb_host_name                    = "experience-kb-rt.ehr.com"
  keyvault_name                   = "n20doabdrnonprodkv"
  subscription_id                 = "e643c042-3710-417e-9e59-27c45e2d46c3"
  app_service_name                = "n21hrportalrtappsvc"
  app_service_resource_group_name = "n21-ptl-rt-hrportaldnn-rgrp"

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience-lpt.ehr.com
module "afd-experience-lpt" {
  source                          = "./modules/afd-embark-env-paas"
  env_name                        = "lpt-paas"
  afd_profile_id                  = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                   = "n21embarklptcdnstg.z19.web.core.windows.net"
  default_tags                    = var.default_tags
  dnn_region                      = "Central US"
  host_name                       = "experience-lpt.ehr.com"
  k8s_private_link_id             = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                      = "Central US"
  enable_primary_region           = true
  k8s_dr_private_link_id          = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                   = "East US2"
  enable_dr_region                = true
  kb_host_name                    = "experience-kb-lpt.ehr.com"
  keyvault_name                   = "n20doabdrnonprodkv"
  subscription_id                 = "e643c042-3710-417e-9e59-27c45e2d46c3"
  app_service_name                = "n21hrportallptappsvc"
  app_service_resource_group_name = "n21-ptl-lpt-hrportaldnn-rgrp"

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

//experience-pqa.ehr.com
module "afd-experience-pqa" {
  source                          = "./modules/afd-embark-env-paas"
  env_name                        = "pqa-paas"
  afd_profile_id                  = azurerm_cdn_frontdoor_profile.profile.id
  cdn_host_name                   = "n21embarkpqacdnstg.z19.web.core.windows.net"
  default_tags                    = var.default_tags
  dnn_region                      = "Central US"
  host_name                       = "experience-prodqa.ehr.com"
  k8s_private_link_id             = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                      = "Central US"
  enable_primary_region           = true
  k8s_dr_private_link_id          = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                   = "East US2"
  enable_dr_region                = true
  kb_host_name                    = "experience-kb-prodqa.ehr.com"
  keyvault_name                   = "n20doabdrnonprodkv"
  subscription_id                 = "e643c042-3710-417e-9e59-27c45e2d46c3"
  app_service_name                = "n21hrportalpqaappsvc"
  app_service_resource_group_name = "n21-ptl-pqa-hrportaldnn-rgrp"

  depends_on = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// OneEmbark - Embark Standard: Sandbox
module "afd-embarkstd-dev" {
  source                                 = "./modules/afd-embark-std"
  env_name                               = "dev"
  afd_profile_id                         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags                           = var.default_tags
  host_name                              = "embarkstd-dev.ehr.com"
  k8s_private_link_id                    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                             = "Central US"
  enable_primary_region                  = true
  k8s_dr_private_link_id                 = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                          = "East US2"
  enable_dr_region                       = false
  keyvault_name                          = "n20doabdrnonprodkv"
  csp_header_assetsblob_microfrontendcdn = "https://n21projectexdnndevstg.blob.core.windows.net/ https://n21microfrontenddevstgsitecdn.azureedge.net/"
  csp_header_microfrontendcdn            = "https://n21microfrontenddevstgsitecdn.azureedge.net/"
  csp_header_assetsblob                  = "https://n21projectexdnndevstg.blob.core.windows.net/assets/"
  csp_header_embarkstd_domain            = "embark-dev.ehr.com"
  csp_header_assetscdn_domain            = "https://assets-embark-dev.ehr.com/"
  csp_header_microfrontendcdn_domain     = "https://microfrontend-embark-dev.ehr.com/"
  csp_header_localhost                   = "localhost:*"
  permissions_policy_value               = "accelerometer=(),camera=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()"
  depends_on                             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// OneEmbark - Embark Standard: DevInt
module "afd-embarkstd-devint" {
  source                                 = "./modules/afd-embark-std"
  env_name                               = "devint"
  afd_profile_id                         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags                           = var.default_tags
  host_name                              = "embark-dev.ehr.com"
  k8s_private_link_id                    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                             = "Central US"
  enable_primary_region                  = true
  k8s_dr_private_link_id                 = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                          = "East US2"
  enable_dr_region                       = false
  keyvault_name                          = "n20doabdrnonprodkv"
  csp_header_assetsblob_microfrontendcdn = "https://n21projectexdnndevstg.blob.core.windows.net/ https://n21microfrontenddevstgsitecdn.azureedge.net/"
  csp_header_microfrontendcdn            = "https://n21microfrontenddevstgsitecdn.azureedge.net/"
  csp_header_assetsblob                  = "https://n21projectexdnndevstg.blob.core.windows.net/assets/"
  csp_header_embarkstd_domain            = "embark-dev.ehr.com"
  csp_header_assetscdn_domain            = "https://assets-embark-dev.ehr.com/"
  csp_header_microfrontendcdn_domain     = "https://microfrontend-embark-dev.ehr.com/"
  csp_header_localhost                   = "localhost:*"
  permissions_policy_value               = "accelerometer=(),camera=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()"
  depends_on                             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// OneEmbark - Embark Standard: QA
module "afd-embarkstd-qa" {
  source                                 = "./modules/afd-embark-std"
  env_name                               = "qa"
  afd_profile_id                         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags                           = var.default_tags
  host_name                              = "embark-qa.ehr.com"
  k8s_private_link_id                    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region                             = "Central US"
  enable_primary_region                  = true
  k8s_dr_private_link_id                 = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region                          = "East US2"
  enable_dr_region                       = false
  keyvault_name                          = "n20doabdrnonprodkv"
  csp_header_assetsblob_microfrontendcdn = "https://n21projectexdnnqastg.blob.core.windows.net/ https://n21microfrontendqastgsitecdn.azureedge.net/"
  csp_header_microfrontendcdn            = "https://n21microfrontendqastgsitecdn.azureedge.net/"
  csp_header_assetsblob                  = "https://n21projectexdnnqastg.blob.core.windows.net/assets/"
  csp_header_embarkstd_domain            = "embark-qa.ehr.com"
  csp_header_assetscdn_domain            = "https://assets-embark-qa.ehr.com/"
  csp_header_microfrontendcdn_domain     = "https://microfrontend-embark-qa.ehr.com/"
  csp_header_localhost                   = "localhost:*"
  permissions_policy_value               = "accelerometer=(),camera=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()"
  depends_on                             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

module "site-down-dev" {
  source                          = "./modules/site-down"
  afd_profile_id                  = azurerm_cdn_frontdoor_profile.profile.id
  dnn_region                      = "Central US"
  app_service_resource_group_name = "WTW-TR-DEVOPS-RGRP"
  app_service_name                = "dvositedowndev"
}


// OneEmbark Security Policy
resource "azurerm_cdn_frontdoor_security_policy" "oneembark-security-policy" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  name                     = "onembark-nonprod-policy"
  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.oneembark-policy.id
      association {
        patterns_to_match = ["/*"]
        domain {
          cdn_frontdoor_domain_id = module.one-embvark-devint.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.one-embvark-devint-admin.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.one-embark-qa.domain_id
        }
        domain {
          cdn_frontdoor_domain_id = module.one-embark-qa-admin.domain_id
        }
      }
    }
  }
}
// OneEmbark - DevInt
module "one-embvark-devint" {
  providers = {
    azurerm           = azurerm
    azurerm.embarkdns = azurerm.embarkdns
  }

  source                 = "./modules/afd-one-embark"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags           = var.default_tags
  enable_dr_region       = false
  enable_primary_region  = true
  env_name               = "devint"
  host_names             = []
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  keyvault_name          = "n20doabdrnonprodkv"
  primary_host_name      = "devint.embark.ehr.com"
  depends_on             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// OneEmbark - QA
module "one-embark-qa" {
  providers = {
    azurerm           = azurerm
    azurerm.embarkdns = azurerm.embarkdns
  }

  source                 = "./modules/afd-one-embark"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags           = var.default_tags
  enable_dr_region       = false
  enable_primary_region  = true
  env_name               = "qa"
  host_names             = []
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  keyvault_name          = "n20doabdrnonprodkv"
  primary_host_name      = "qa.embark.ehr.com"
  depends_on             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// OneEmbark Admin - DevInt
module "one-embvark-devint-admin" {
  providers = {
    azurerm           = azurerm
    azurerm.embarkdns = azurerm.embarkdns
  }

  source                 = "./modules/afd-one-embark"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags           = var.default_tags
  enable_dr_region       = false
  enable_primary_region  = true
  env_name               = "devint-admin"
  host_names             = []
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  keyvault_name          = "n20doabdrnonprodkv"
  primary_host_name      = "admin.devint.embark.ehr.com"
  depends_on             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}

// OneEmbark Admin - QA
module "one-embark-qa-admin" {
  providers = {
    azurerm           = azurerm
    azurerm.embarkdns = azurerm.embarkdns
  }

  source                 = "./modules/afd-one-embark"
  afd_profile_id         = azurerm_cdn_frontdoor_profile.profile.id
  default_tags           = var.default_tags
  enable_dr_region       = false
  enable_primary_region  = true
  env_name               = "qa-admin"
  host_names             = []
  k8s_dr_private_link_id = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n20-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_dr_region          = "East US2"
  k8s_private_link_id    = "/subscriptions/e643c042-3710-417e-9e59-27c45e2d46c3/resourceGroups/n21-doa-bdr-nonprod-rgrp/providers/Microsoft.Network/privateLinkServices/aks-privatelink"
  k8s_region             = "Central US"
  keyvault_name          = "n20doabdrnonprodkv"
  primary_host_name      = "admin.qa.embark.ehr.com"
  depends_on             = [azurerm_cdn_frontdoor_profile.profile, azurerm_cdn_frontdoor_firewall_policy.policy]
}
