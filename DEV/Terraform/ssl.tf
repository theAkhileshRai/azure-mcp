# SSL cert
# https://www.terraform.io/docs/providers/azurerm/r/app_service_certificate.html
# resource "azurerm_app_service_certificate" "cert" {
#   name                = "__webapp_certificate_name__"
#   resource_group_name = "__resource_group_name__"
#   location            = "__location__"
#   pfx_blob            = "__webapp_certificate_data__"
#   password            = "__webapp_certificate_pw__"
#   tags                = local.appx_tags
# }

resource "azurerm_app_service_certificate" "cert" {
  name                = "embark-dev-ehr-com" # Should be replaced with var.keyvault_certificate_name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_secret_id = data.azurerm_key_vault_certificate.pexcert.secret_id # Referenced from azurerm_key_vault_certificate data source
  tags                = local.appx_tags
}