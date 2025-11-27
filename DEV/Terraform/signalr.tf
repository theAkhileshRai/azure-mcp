# replace "name" with the label you want to assign to this block
resource "azurerm_signalr_service" "signalr" {
# insert signalr name below
  name                = "${local.regioncodeprefix}${var.env_code}signalr"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.signalr_sku_name
    capacity = var.signalr_sku_capacity
  }

  cors {
    allowed_origins = local.signalr_cors
  }

# The features block is deprecated, use connectivity_logs_enabled, messaging_logs_enabled, live_trace_enabled and service_mode instead.
# https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/signalr_service

#   features {
#     flag  = "ServiceMode"
#     value = "Serverless"
#   }

  tags = local.appx_tags

  lifecycle {
    prevent_destroy = true
  }
}