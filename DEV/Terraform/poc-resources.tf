
## ================ APP SERVICES
# Use Registration Svc Plan for all App Services
resource "azurerm_app_service" "registrationui-stg" {
  name                = "${local.regioncodeprefix}registrationui${var.env_code}appsvc-stg"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.registration.id
  https_only          = "true" # force https
  tags                = local.sa_tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.usermanagedidentity.id
    ]
  }
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0"        # http://jira.ehr.com/browse/PEX-2591
    http2_enabled               = "true"        # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
  }
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  lifecycle {
    ignore_changes = [
      site_config["scm_type"]
    ]
  }
}

resource "azurerm_app_service" "registrationapi-stg" {
  name                = "${local.regioncodeprefix}registrationapi${var.env_code}appsvc-stg"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.registration.id
  https_only          = "true" # force https
  tags                = local.sa_tags
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.usermanagedidentity.id
    ]
  }
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0"         # http://jira.ehr.com/browse/PEX-2591
    http2_enabled               = "true"         # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
  }
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  lifecycle {
    ignore_changes = [
      site_config["scm_type"]
    ]
  }
}

resource "azurerm_app_service" "b2cext-stg" {
  name                = "${local.regioncodeprefix}b2cext${var.env_code}appsvc-stg"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.registration.id
  https_only          = "true" # force https
  tags                = local.sa_tags
  /*   tags                = local.appx_tags */
  identity {
    type = "SystemAssigned"
  }
  # AlwaysOn true: https://docs.microsoft.com/en-us/azure/app-service/configure-common#configure-general-settings
  site_config {
    always_on                   = "true"
    scm_use_main_ip_restriction = "true"
    dotnet_framework_version    = "v6.0"         # http://jira.ehr.com/browse/PEX-2591
    http2_enabled               = "true"         # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services
  }
  # workaround for Message="Operation not supported: RepoUrl VSTSRM is not supported."
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8171
  lifecycle {
    ignore_changes = [
      site_config["scm_type"]
    ]
  }
}
# end

# ============== KV and Certificate
data "azurerm_key_vault" "pexkeyvault-stg" {
  name                = "devops-hcbtro-dev-kv"
  resource_group_name = "devops-kv-rgrp"
}

data "azurerm_key_vault_certificate" "pexcert-stg" {
  name         = "signin-embarkstd-stg-dot-ehr-com"
  key_vault_id = data.azurerm_key_vault.pexkeyvault-stg.id
}

resource "azurerm_app_service_certificate" "cert-stg" {
  name                = "signin-embarkstd-stg-dot-ehr-com" # Should be replaced with var.keyvault_certificate_name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_secret_id = data.azurerm_key_vault_certificate.pexcert-stg.secret_id # Referenced from azurerm_key_vault_certificate data source
  tags                = local.sa_tags
}


# ============== CUSTOM DOMAINS
resource "azurerm_app_service_custom_hostname_binding" "registrationui-stg" {
  hostname            = "signin-embarkstd-stg.ehr.com"
  app_service_name    = azurerm_app_service.registrationui-stg.name
  resource_group_name = var.resource_group_name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.cert-stg.thumbprint # Referenced from azurerm_app_service_certificate data source
  depends_on = [
    azurerm_app_service.registrationui-stg,
    azurerm_app_service_certificate.cert-stg
  ]
}

resource "azurerm_app_service_custom_hostname_binding" "b2cext-stg" {
  hostname            = "b2cext-embarkstd-stg.ehr.com"
  app_service_name    = azurerm_app_service.b2cext-stg.name
  resource_group_name = var.resource_group_name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.cert-stg.thumbprint # Referenced from azurerm_app_service_certificate data source
  depends_on = [
    azurerm_app_service.b2cext-stg,
    azurerm_app_service_certificate.cert-stg
  ]
}