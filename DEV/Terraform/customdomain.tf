# add custom domain bindings for dnn, registration and gateway
# https://www.terraform.io/docs/providers/azurerm/r/app_service_custom_hostname_binding.html

resource "azurerm_app_service_custom_hostname_binding" "registrationui" {
  hostname            = local.registration_fqdn
  app_service_name    = azurerm_app_service.registrationui.name
  resource_group_name = var.resource_group_name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.cert.thumbprint # Referenced from azurerm_app_service_certificate data source
  depends_on = [
    azurerm_app_service_certificate.cert
  ]
}

resource "azurerm_app_service_custom_hostname_binding" "gateway" {
  hostname            = local.gateway_fqdn
  app_service_name    = azurerm_app_service.gateway.name
  resource_group_name = var.resource_group_name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.cert.thumbprint # Referenced from azurerm_app_service_certificate data source
  depends_on = [
    azurerm_app_service_certificate.cert
  ]
}

// PEX-3563 - DevOps - [Tech Debt] Azure GuardRails 100 - B2C extensions and SAML test
resource "azurerm_app_service_custom_hostname_binding" "b2cext" {
  hostname            = local.b2cext_fqdn
  app_service_name    = azurerm_app_service.b2cext.name
  resource_group_name = var.resource_group_name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.cert.thumbprint # Referenced from azurerm_app_service_certificate data source
  depends_on = [
    azurerm_app_service_certificate.cert
  ]
}

// PEX-3939 - [DevOps] Assign custom domains to Client Admin app services
resource "azurerm_app_service_custom_hostname_binding" "clientadminrcmicro" {
  hostname            = local.cltadmin_fqdn
  app_service_name    = azurerm_app_service.cltadmin.name
  resource_group_name = var.resource_group_name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.cert.thumbprint # Referenced from azurerm_app_service_certificate data source
  depends_on = [
    azurerm_app_service_certificate.cert
  ]
}

// PEX-5542 - [GuardRails] Auth-Test Custom Domain
resource "azurerm_app_service_custom_hostname_binding" "samltest" {
  hostname            = local.samltest_fqdn
  app_service_name    = azurerm_app_service.samltest.name
  resource_group_name = var.resource_group_name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.cert.thumbprint # Referenced from azurerm_app_service_certificate data source
  depends_on = [
    azurerm_app_service_certificate.cert
  ]
}
