resource "azurerm_resource_group" "resource-group" {
  location = local.location
  name     = local.resource_group_name
  tags = merge({}, var.default_tags)
  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], tags["RegulatoryStandards"]]
  }
}

resource "azurerm_cdn_frontdoor_profile" "profile" {
  name                     = local.frontdoor_name
  resource_group_name      = azurerm_resource_group.resource-group.name
  response_timeout_seconds = 240
  sku_name                 = "Premium_AzureFrontDoor"
  tags = merge({}, var.default_tags)
  identity {
    type = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.kv-identity.id]
  }

  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"]]
  }
  depends_on = [
    azurerm_resource_group.resource-group,
  ]
}

data "azurerm_user_assigned_identity" "kv-identity" {
  name                = local.kv_identity_name
  resource_group_name = "devops-kv-rgrp"
}

# Role Assignment CDN Profile Contributor

resource "azurerm_role_assignment" "cdn_profile_contributor" {
  scope                = azurerm_cdn_frontdoor_profile.profile.id
  role_definition_name = "CDN Profile Contributor"
  principal_id         = var.cdn_contributor_spn
  
}