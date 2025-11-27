# single appinsights 
# would be nice if MS could make a better API too make it easier to hook Appinsights to Appservice; https://github.com/terraform-providers/terraform-provider-azurerm/issues/1303
resource "azurerm_application_insights" "tfaitfappx" {
  name                = "${var.region_code}${var.app_name}${var.env_code}appinsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = data.azurerm_log_analytics_workspace.logworkspace.id
  tags                = local.appx_tags
}

resource "azurerm_application_insights" "registration" {
  name                = "${var.region_code}${var.app_name}${var.env_code}appinsightsregistration"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = data.azurerm_log_analytics_workspace.logworkspace.id
  tags                = local.sa_tags
}

# n21projectexdnndevappinsights already exists 
# resource "azurerm_application_insights" "projectexdnn" {
#   name                = "${var.region_code}projectexdnn${var.env_code}appinsights"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   application_type    = "web"
#   workspace_id        = data.azurerm_log_analytics_workspace.logworkspace.id
#   tags                = local.appx_tags
# }

data "azurerm_application_insights" "projectexdnn" {
  name                = "${var.region_code}projectexdnn${var.env_code}appinsights"
  # location            = var.location
  resource_group_name = var.resource_group_name
  # application_type    = "web"
  # workspace_id        = data.azurerm_log_analytics_workspace.logworkspace.id
  # tags                = local.appx_tags
}

resource "azurerm_role_assignment" "projectexdnn_appinsights_singleAuthAppInsightsGroup" {
  role_definition_name = "Reader"
  //name = "${var.region_code}projectexdnn${var.env_code}singleAuthAppInsightsGroupReader"
  scope = data.azurerm_application_insights.projectexdnn.id
  principal_id = var.singleauthappinsights_adgroup_objectid
}

output "instrumentation_key" {
  value = "${azurerm_application_insights.tfaitfappx.instrumentation_key}"
}

output "app_id" {
  value = "${azurerm_application_insights.tfaitfappx.app_id}"
}