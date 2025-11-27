# resource "azurerm_logic_app_workflow" "removemalware" {
#   name                = "${local.regioncodeprefix}removemalware${var.env_code}logicapp"
#   location            = var.location
#   resource_group_name = var.resource_group_name
# }

resource "azurerm_logic_app_workflow" "removemalware" {
 enabled                         = true
 location                        = var.location
 name                            = "${local.regioncodeprefix}removemalware${var.env_code}logicapp"
 resource_group_name             = var.resource_group_name
	parameters                      = {
		"$connections" = jsonencode(
            {
				mdcalert = {
					connectionId   = var.mdcalert_connection_id
					connectionName = var.mdcalert_connection_name
                    id             = var.mdcalert_id
                }
            }
        )
    }
    tags                            = local.appx_tags
	workflow_parameters             = {
		"$connections" = jsonencode(
            {
				defaultValue = {}
				type         = "Object"
            }
        )
    }
    workflow_schema                 = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
    workflow_version                = "1.0.0.0"

 lifecycle {
    prevent_destroy = true
    ignore_changes  = [identity]
 }

}