# PEX-7440 - [DevOps] Create Event Grid topic $(regioncode)pexdoclib$(envCode)stg-scan-complete

resource "azurerm_eventgrid_system_topic" "doclibstgeventgridtopic" {
  name                   = "${local.regioncodeprefix}doclib${var.env_code}stg-scan-complete"
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_arm_resource_id = azurerm_storage_account.documentlibrary.id
  topic_type             = "Microsoft.Storage.StorageAccounts"

  tags = local.appx_tags
}