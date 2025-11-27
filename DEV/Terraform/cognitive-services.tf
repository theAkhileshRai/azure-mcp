# PEX-3902 - Create Translator Resource in QA env
# PEX-3429 - Test changes in Dev
# resource "azurerm_cognitive_account" "translatortext" {
#     name                = "${local.regioncodeprefix}translatortext${var.env_code}csvc"
#     location            = var.location
#     resource_group_name = "__resource_group_name__"
#     kind                = "TextTranslation"
#     sku_name            = "S1"
#     # local_auth_enabled  = false
#     identity {
#         type = "SystemAssigned"
#     }
#     tags = {
#         "AppID" = "__AppID__"
#         "IAC" = "${local.iac_tag}"
#         "business" = "__business__"
#         "program" = "__program__"
#         "product" = "__product__"
#         "region" = "__region__"
#         "datacenter" = "__regionCode__"
#         "hostingprovider" = "__hostingprovider__"
#     }
# }
