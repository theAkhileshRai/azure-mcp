# PEX-3644 - Managed Identity to utilize Azure AD Authentication e.g. Azure SQL Database, Azure Storage Account,
resource "azurerm_user_assigned_identity" "usermanagedidentity" {
  name                = "${local.regioncodeprefix}${var.env_code}mi"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.appx_tags
}
