# https://dev.azure.com/wtwdst/HRPortal/_workitems/edit/15015 - [Dev Ops]: Create domain https://embark-dev.ehr.com/
/*
## notes ##
https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html

Front End AGW
This template creates the following
 VNET with a /29 (8 IPs) in the 172.16.x.z/29 IP space: __appsvcVNET__
 - AGW subnet /29 (8 IPs)
 AGW V2 with WAF 
 - HTTPs bindings (443)
 - App service backend for DNN UI (custom ssl certificate); 'primary' (VNET uses the app service as reference)
 - App service backend for Registraion UI (custom ssl certificate)
 - App service backend for API Gateway  (custom ssl certificate)
 - App service backend for B2C Ext (custom ssl certificate)
 - App service backend for Client Admin Microfrontend rootconfig (custom ssl certificate)
 REQUIRES:
 - SSL Certificate uploaded as 'secure file' in AZDO pipeline
 -- SSL Cert must have SNI DNS for:
    app service names
    AGW public IP name
    azure traffic manager profile 
 - DNN app service pre-deployed: __dnn_app_service_name__ 

For available VNETs, see: https://dev.azure.com/wtwdst/DevOps-Terraform/_git/Terraform?path=%2FScripts%2Fagw&version=GBscripts&_a=contents
file: vnets_in_use.txt

*/

# create random id for agw resources (KeyVault)
# using the 'dec' export; see https://www.terraform.io/docs/providers/random/r/id.html 
resource "random_id" "agw" {
  byte_length = 2
}
## NSG provisioning only. All rules should be handled via configuration files / Az CLI 
# This handles Azure app service tiers (app)
# must be provisioned before the subnet is
# agw nsg
# agw nsg for AGW v2 must have different defaults enabled.
resource "azurerm_network_security_group" "agw" {
  name                = "${var.agw_name}-nsgagw"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.appx_tags

  # set the rules here. these have to override the default NSG to be compatible w/ AGW V2
  security_rule {
    name                       = "AllowAzureAGWv2"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

## VNET and Subnets
# VNET is /28 8 IPs
resource "azurerm_virtual_network" "agw" {
  name                = "${var.agw_name}-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["${var.appsvcVNET}/29"]
  tags                = local.appx_tags
  lifecycle {
    ignore_changes = [
      ddos_protection_plan
    ]
  }
}
# one AGW subnet only: /29 8 IPs
resource "azurerm_subnet" "agw" {
  name                 = "${var.agw_name}-vnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.agw.name
  address_prefixes     = ["${var.appsvcVNET}/29"]
}
## NSG associations
# requires the subnets created first
resource "azurerm_subnet_network_security_group_association" "agw" {
  subnet_id                 = azurerm_subnet.agw.id
  network_security_group_id = azurerm_network_security_group.agw.id
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.agw_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  # dns name is required for Azure Traffic Manager: https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-endpoint-types#azure-endpoints
  domain_name_label = "${var.agw_name}-pip"
  tags              = local.appx_tags
}


/* 
AGW configuration:
 Front end HTTP and HTTPS listeners
 5 Pools, Probes
 - DNN UI 
 - Registration UI
 - API Gateway (Ocelot)
 - B2C Ext
 - Client Admin Microfrontend
 SSL Certificate
*/
resource "azurerm_application_gateway" "agw" {
  name                = var.agw_name
  resource_group_name = azurerm_virtual_network.agw.resource_group_name
  location            = var.location
  lifecycle {
    prevent_destroy = true
  }
  tags = local.appx_tags
  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = var.agw_capacity
  }
  /*  # SSL policy: only allow TLS 1.2 ; see http://jira.ehr.com/browse/DEVOPS-12875
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"

  } */

  # SSL policy: only allow TLS 1.2 and custom cipher: https://cetknowledgehub.willistowerswatson.com/docs/standards/azure/networking/appgateway#cipher-suite
  ssl_policy {
    policy_type          = "Custom"
    min_protocol_version = "TLSv1_2"
    cipher_suites = [
      "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",
      "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
    ]

  }

  # testing attached policy, this assumes agw and waf policy are in same Terraform deploy
  #firewall_policy_id = azurerm_web_application_firewall_policy.waf.id

  # use an AZDO variable:
  firewall_policy_id = azurerm_web_application_firewall_policy.waf.id

  enable_http2 = true # PEX-3386 - DevOps - Enable HTTPS2 on Application Gateway and App Services

  custom_error_configuration {
    status_code           = "HttpStatus502" # Backend Pool unhealthy
    custom_error_page_url = "https://wtwdevopscommon.blob.core.windows.net/site-down/index.html"
    # custom_error_page_url = "https://embark-qa.ehr.com/404/" # PEX-7065 - Update 403 and 502 custom error page
  }
  custom_error_configuration {
    status_code           = "HttpStatus403" # WAF block
    custom_error_page_url = "https://wtwdevopscommon.blob.core.windows.net/site-down/index.html"
    # custom_error_page_url = "https://embark-qa.ehr.com/404/" # PEX-7065 - Update 403 and 502 custom error page
  }

  gateway_ip_configuration {
    name      = "${var.agw_name}-ip-cfg"
    subnet_id = azurerm_subnet.agw.id
  }

  frontend_ip_configuration {
    name                 = "${var.agw_name}-feip"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  frontend_port {
    name = "${var.agw_name}-http"
    port = 80
  }
  frontend_port {
    name = "${var.agw_name}-https"
    port = 443
  }

  /* 
  5 probes: 
    1 for registration 
    1 for Gateway
    1 for B2C Extensions
    1 for Client Admin Root Config Microfrontend
    1 for SAMLTest
  */

  # }
  probe {
    name                                      = "registration"
    interval                                  = "30"
    protocol                                  = "Https"
    path                                      = var.agw_monitor_probe_registration
    timeout                                   = "120"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = "true"
    match {
      status_code = ["200-399"]
    }

  }
  probe {
    name                                      = "gateway"
    interval                                  = "30"
    protocol                                  = "Https"
    path                                      = var.agw_monitor_probe_gateway
    timeout                                   = "120"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = "true"
    match {
      status_code = ["200-399"]
      # gw will return 404 for '/' 
      # status_code       = ["200-399","404"]
    }

  }

  # PEX-3563 - DevOps - [Tech Debt] Azure GuardRails 100 - B2C extensions and SAML test
  probe {
    name                                      = "b2cext"
    interval                                  = "30"
    protocol                                  = "Https"
    path                                      = var.agw_monitor_probe_b2cext
    timeout                                   = "120"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = "true"
    match {
      status_code = ["200-399"]
      # gw will return 404 for '/' 
      # status_code       = ["200-399","404"]
    }

  }

  // PEX-3939 - [DevOps] Assign custom domains to Client Admin app services
  probe {
    name                                      = "cltadmin"
    interval                                  = "30"
    protocol                                  = "Https"
    path                                      = var.agw_monitor_probe_cltadmin
    timeout                                   = "120"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = "true"
    match {
      status_code = ["200-399"]
    }

  }

  // PEX-5542 - [GuardRails] Auth-Test Custom Domain
  probe {
    name                                      = "samltest"
    interval                                  = "30"
    protocol                                  = "Https"
    path                                      = var.agw_monitor_probe_samltest
    timeout                                   = "120"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = "true"
    match {
      status_code = ["200-399"]
    }

  }

  ## Pools 
  # registration
  backend_address_pool {
    name = "registration"
    # this needs to be the app service name, CANNOT use fqdn here since DNS will resolve back to the AGW 
    fqdns = ["${azurerm_app_service.registrationui.name}.azurewebsites.net"]
  }
  # gateway
  backend_address_pool {
    name = "gateway"
    # this needs to be the app service name, CANNOT use fqdn here since DNS will resolve back to the AGW 
    fqdns = ["${azurerm_app_service.gateway.name}.azurewebsites.net"]
  }
  # B2C ext
  # PEX-3563 - DevOps - [Tech Debt] Azure GuardRails 100 - B2C extensions and SAML test
  backend_address_pool {
    name = "b2cext"
    # this needs to be the app service name, CANNOT use fqdn here since DNS will resolve back to the AGW 
    fqdns = ["${azurerm_app_service.b2cext.name}.azurewebsites.net"]
  }
  # Client Admin Root Config Microfrontend
  # PEX-3939 - [DevOps] Assign custom domains to Client Admin app services
  backend_address_pool {
    name = "cltadmin"
    # this needs to be the app service name, CANNOT use fqdn here since DNS will resolve back to the AGW 
    fqdns = ["${azurerm_app_service.cltadmin.name}.azurewebsites.net"]
  }

  # PEX-5542 - [GuardRails] Auth-Test Custom Domain
  backend_address_pool {
    name = "samltest"
    # this needs to be the app service name, CANNOT use fqdn here since DNS will resolve back to the AGW 
    fqdns = ["${azurerm_app_service.samltest.name}.azurewebsites.net"]
  }

  ## region: SSL certificate required
  # Single SSL Cert with SNI enabled for all possible DNS entries
  # Https listener needs SSL Certificate. Currently, TF doesn't support AGW V2 + KeyVault integration
  # for host name, use fqdn
  ssl_certificate {
    name                = var.keyvault_certificate_name
    key_vault_secret_id = data.azurerm_key_vault_certificate.pexcert.versionless_secret_id
  }

  # registration
  # http (80) listener is only redirect
  http_listener {
    name                           = "registration-http-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-http"
    protocol                       = "Http"
    host_name                      = local.registration_fqdn
  }
  redirect_configuration {
    name                 = "http-to-https-redirect-registration"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "registration-https-lstn"
  }
  request_routing_rule {
    name                        = "http-to-https-requests-registration"
    rule_type                   = "Basic"
    http_listener_name          = "registration-http-lstn"
    redirect_configuration_name = "http-to-https-redirect-registration"
    rewrite_rule_set_name       = "headersecurity_registrationui" # reference for rewrite rule
  }
  # need listener https (443) for each request routing rule / FQDN (host_names), same SSL cert is used
  http_listener {
    name                           = "registration-https-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-https"
    protocol                       = "Https"
    ssl_certificate_name           = var.keyvault_certificate_name
    host_name                      = local.registration_fqdn
  }
  backend_http_settings {
    name                                = "registration"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 120
    host_name                           = local.registration_fqdn
    pick_host_name_from_backend_address = "false"
    probe_name                          = "registration"
  }
  # Configure a routing rule to send traffic from a given frontend IP address to one or more backend targets. A routing rule must contain a listener and at least one backend target.
  request_routing_rule {
    name                       = "registration-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "registration-https-lstn"
    backend_address_pool_name  = "registration"
    backend_http_settings_name = "registration"
    rewrite_rule_set_name      = "headersecurity_registrationui" # reference for rewrite rule
  }

  # gateway
  # http (80) listener is only redirect
  http_listener {
    name                           = "gateway-http-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-http"
    protocol                       = "Http"
    host_name                      = local.gateway_fqdn
  }
  redirect_configuration {
    name                 = "http-to-https-redirect-gateway"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "gateway-https-lstn"
  }
  request_routing_rule {
    name                        = "http-to-https-requests-gateway"
    rule_type                   = "Basic"
    http_listener_name          = "gateway-http-lstn"
    redirect_configuration_name = "http-to-https-redirect-gateway"
    rewrite_rule_set_name       = "headersecurity" # reference for rewrite rule
  }
  # need listener https (443) for each request routing rule / FQDN (host_names), same SSL cert is used
  http_listener {
    name                           = "gateway-https-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-https"
    protocol                       = "Https"
    ssl_certificate_name           = var.keyvault_certificate_name
    host_name                      = local.gateway_fqdn
  }
  backend_http_settings {
    name                                = "gateway"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 120
    host_name                           = local.gateway_fqdn
    pick_host_name_from_backend_address = "false"
    probe_name                          = "gateway"
  }
  # Configure a routing rule to send traffic from a given frontend IP address to one or more backend targets. A routing rule must contain a listener and at least one backend target.
  request_routing_rule {
    name                       = "gateway-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "gateway-https-lstn"
    backend_address_pool_name  = "gateway"
    backend_http_settings_name = "gateway"
    rewrite_rule_set_name      = "headersecurity" # reference for rewrite rule
  }
  # B2C Ext 
  # PEX-3563 - DevOps - [Tech Debt] Azure GuardRails 100 - B2C extensions and SAML test
  # http (80) listener is only redirect
  http_listener {
    name                           = "b2cext-http-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-http"
    protocol                       = "Http"
    host_name                      = local.b2cext_fqdn
  }
  redirect_configuration {
    name                 = "http-to-https-redirect-b2cext"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "b2cext-https-lstn"
  }
  request_routing_rule {
    name                        = "http-to-https-requests-b2cext"
    rule_type                   = "Basic"
    http_listener_name          = "b2cext-http-lstn"
    redirect_configuration_name = "http-to-https-redirect-b2cext"
    rewrite_rule_set_name       = "headersecurity" # reference for rewrite rule
  }


  # need listener https (443) for each request routing rule / FQDN (host_names), same SSL cert is used
  http_listener {
    name                           = "b2cext-https-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-https"
    protocol                       = "Https"
    ssl_certificate_name           = var.keyvault_certificate_name
    host_name                      = local.b2cext_fqdn
  }
  backend_http_settings {
    name                                = "b2cext"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 120
    host_name                           = local.b2cext_fqdn
    pick_host_name_from_backend_address = "false"
    probe_name                          = "b2cext"
  }
  # Configure a routing rule to send traffic from a given frontend IP address to one or more backend targets. A routing rule must contain a listener and at least one backend target.
  request_routing_rule {
    name                       = "b2cext-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "b2cext-https-lstn"
    backend_address_pool_name  = "b2cext"
    backend_http_settings_name = "b2cext"
    rewrite_rule_set_name      = "headersecurity" # reference for rewrite rule
  }

  # Client Admin RootConfig Microfrontend 
  # PEX-3939 - [DevOps] Assign custom domains to Client Admin app services
  # http (80) listener is only redirect
  http_listener {
    name                           = "cltadmin-http-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-http"
    protocol                       = "Http"
    host_name                      = local.cltadmin_fqdn
  }
  redirect_configuration {
    name                 = "http-to-https-redirect-cltadmin"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "cltadmin-https-lstn"
  }
  request_routing_rule {
    name                        = "http-to-https-requests-cltadmin"
    rule_type                   = "Basic"
    http_listener_name          = "cltadmin-http-lstn"
    redirect_configuration_name = "http-to-https-redirect-cltadmin"
    rewrite_rule_set_name       = "headersecurity" # reference for rewrite rule
  }
  # need listener https (443) for each request routing rule / FQDN (host_names), same SSL cert is used
  http_listener {
    name                           = "cltadmin-https-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-https"
    protocol                       = "Https"
    ssl_certificate_name           = var.keyvault_certificate_name
    host_name                      = local.cltadmin_fqdn
  }
  backend_http_settings {
    name                                = "cltadmin"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 120
    host_name                           = local.cltadmin_fqdn
    pick_host_name_from_backend_address = "false"
    probe_name                          = "cltadmin"
  }
  # Configure a routing rule to send traffic from a given frontend IP address to one or more backend targets. A routing rule must contain a listener and at least one backend target.
  request_routing_rule {
    name                       = "cltadmin-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "cltadmin-https-lstn"
    backend_address_pool_name  = "cltadmin"
    backend_http_settings_name = "cltadmin"
    rewrite_rule_set_name      = "headersecurity" # reference for rewrite rule
  }

  # SAML Test
  # # PEX-5542 - [GuardRails] Auth-Test Custom Domain
  # http (80) listener is only redirect
  http_listener {
    name                           = "samltest-http-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-http"
    protocol                       = "Http"
    host_name                      = local.samltest_fqdn
  }
  redirect_configuration {
    name                 = "http-to-https-redirect-samltest"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "samltest-https-lstn"
  }
  request_routing_rule {
    name                        = "http-to-https-requests-samltest"
    rule_type                   = "Basic"
    http_listener_name          = "samltest-http-lstn"
    redirect_configuration_name = "http-to-https-redirect-samltest"
    rewrite_rule_set_name       = "headersecurity" # reference for rewrite rule
  }
  # need listener https (443) for each request routing rule / FQDN (host_names), same SSL cert is used
  http_listener {
    name                           = "samltest-https-lstn"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-https"
    protocol                       = "Https"
    ssl_certificate_name           = var.keyvault_certificate_name
    host_name                      = local.samltest_fqdn
  }
  backend_http_settings {
    name                                = "samltest"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 120
    host_name                           = local.samltest_fqdn
    pick_host_name_from_backend_address = "false"
    probe_name                          = "samltest"
  }
  # Configure a routing rule to send traffic from a given frontend IP address to one or more backend targets. A routing rule must contain a listener and at least one backend target.
  request_routing_rule {
    name                       = "samltest-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "samltest-https-lstn"
    backend_address_pool_name  = "samltest"
    backend_http_settings_name = "samltest"
    rewrite_rule_set_name      = "headersecurity" # reference for rewrite rule
  }
  rewrite_rule_set {
    name = "headersecurity" # must match request_routing_rule -> rewrite_rule_set_name  reference

    rewrite_rule { # delete reponse header server
      name          = "Remove-Headers"
      rule_sequence = 100 # each rule needs a sequence #

      response_header_configuration {
        header_name  = "Server"
        header_value = "" # To delete a response header set this property to an empty string.
      }
      response_header_configuration {
        header_name  = "X-Powered-By"
        header_value = "" # To delete a response header set this property to an empty string.
      }
      response_header_configuration {
        header_name  = "X-AspNet-Version"
        header_value = "" # To delete a response header set this property to an empty string.
      }
    } # end rewrite_rule

    rewrite_rule { # add reponse header server
      name          = "Add-Headers"
      rule_sequence = 200 # each rule needs a sequence #

      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubDomains; preload" # To add a response header set this property
      }
      # X-Content-Type-Options
      response_header_configuration {
        header_name  = "X-Content-Type-Options"
        header_value = "nosniff" # To add a response header set this property
      }
      # Referrer-Policy
      response_header_configuration {
        header_name  = "Referrer-Policy"
        header_value = "no-referrer" # To add a response header set this property
      }
      # X-Permitted-Cross-Domain-Policies - PEX-2786
      response_header_configuration {
        header_name  = "X-Permitted-Cross-Domain-Policies"
        header_value = "none" # To add a response header set this property
      }
      # X-Frame-Options - PEX-6610
      response_header_configuration {
        header_name  = "X-Frame-Options"
        header_value = "SAMEORIGIN" # To add a response header set this property
      }

      response_header_configuration {
        header_name  = local.cache_control_name
        header_value = local.cache_control_value # To add a response header set this property
      }

      response_header_configuration {
        header_name  = local.permissions_name
        header_value = local.permissions_value # To add a response header set this property
      }
    } # end rewrite_rule

    rewrite_rule { # add set separate for CSP
      name          = "Add-CSP-Registration"
      rule_sequence = 300 # each rule needs a sequence #

      response_header_configuration {
        header_name = "Content-Security-Policy"
        # default-src; form-action; base-uri; frame-src; frame-ancestors; object-src;
        header_value = local.csp_registration_defaults
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # connect-src;
        header_value = local.csp_registration_connect
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # script-src;
        header_value = local.csp_registration_script
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # style-src;
        header_value = local.csp_registration_style
      }
      #
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # img-src;
        header_value = local.csp_registration_img
      }
      #
    } # end rewrite_rule

    rewrite_rule { # add set separate for CSP
      name          = "Add-CSP-Rootconfig"
      rule_sequence = 400 # each rule needs a sequence #

      response_header_configuration {
        header_name = "Content-Security-Policy"
        # default-src; form-action; base-uri; frame-src; frame-ancestors; object-src;
        header_value = local.csp_rootconfig_defaults
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # connect-src;
        header_value = local.csp_rootconfig_connect
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # script-src;
        header_value = local.csp_rootconfig_script
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # style-src;
        header_value = local.csp_rootconfig_style
      }
      #
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # img-src;
        header_value = local.csp_rootconfig_img
      }
      #
    } # end rewrite_rule
  }   # end rewrite_rule_set - headersecurity 

  # PEX-2876 - Headers For RegistrationUI
  rewrite_rule_set {
    name = "headersecurity_registrationui" # must match request_routing_rule -> rewrite_rule_set_name  reference

    rewrite_rule { # delete reponse header server
      name          = "Remove-Headers"
      rule_sequence = 100 # each rule needs a sequence #

      response_header_configuration {
        header_name  = "Server"
        header_value = "" # To delete a response header set this property to an empty string.
      }
      response_header_configuration {
        header_name  = "X-Powered-By"
        header_value = "" # To delete a response header set this property to an empty string.
      }
      response_header_configuration {
        header_name  = "X-AspNet-Version"
        header_value = "" # To delete a response header set this property to an empty string.
      }
    } # end rewrite_rule

    rewrite_rule { # add reponse header server
      name          = "Add-Headers"
      rule_sequence = 200 # each rule needs a sequence #

      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubDomains; preload" # To add a response header set this property
      }
      # X-Content-Type-Options
      response_header_configuration {
        header_name  = "X-Content-Type-Options"
        header_value = "nosniff" # To add a response header set this property
      }
      # Referrer-Policy
      response_header_configuration {
        header_name  = "Referrer-Policy"
        header_value = "no-referrer" # To add a response header set this property
      }
      # X-Permitted-Cross-Domain-Policies - PEX-2786
      response_header_configuration {
        header_name  = "X-Permitted-Cross-Domain-Policies"
        header_value = "none" # To add a response header set this property
      }
      # X-Frame-Options - PEX-5650
      response_header_configuration {
        header_name  = "X-Frame-Options"
        header_value = "SAMEORIGIN" # To add a response header set this property
      }

      response_header_configuration {
        header_name  = local.cache_control_name
        header_value = local.cache_control_value # To add a response header set this property
      }

      response_header_configuration {
        header_name  = local.permissions_name
        header_value = local.permissions_value_registration # To add a response header set this property
      }
    } # end rewrite_rule

    rewrite_rule { # add set separate for CSP
      name          = "Add-CSP"
      rule_sequence = 300 # each rule needs a sequence #

      response_header_configuration {
        header_name = "Content-Security-Policy"
        # default-src; form-action; base-uri; frame-src; frame-ancestors; object-src;
        header_value = local.csp_registration_defaults
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # connect-src;
        header_value = local.csp_registration_connect
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # script-src;
        header_value = local.csp_registration_script_nounsafeinline
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # style-src;
        header_value = local.csp_registration_style
      }
      #
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # img-src;
        header_value = local.csp_registration_img
      }
      #
    } # end rewrite_rule
  }   # end rewrite_rule_set

  # PEX-2876 - Headers For RootConfig
  rewrite_rule_set {
    name = "headersecurity_rootconfig" # must match request_routing_rule -> rewrite_rule_set_name  reference

    rewrite_rule { # delete reponse header server
      name          = "Remove-Headers"
      rule_sequence = 100 # each rule needs a sequence #

      response_header_configuration {
        header_name  = "Server"
        header_value = "" # To delete a response header set this property to an empty string.
      }
      response_header_configuration {
        header_name  = "X-Powered-By"
        header_value = "" # To delete a response header set this property to an empty string.
      }
      response_header_configuration {
        header_name  = "X-AspNet-Version"
        header_value = "" # To delete a response header set this property to an empty string.
      }
    } # end rewrite_rule

    rewrite_rule { # add reponse header server
      name          = "Add-Headers"
      rule_sequence = 200 # each rule needs a sequence #

      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubDomains; preload" # To add a response header set this property
      }
      # X-Content-Type-Options
      response_header_configuration {
        header_name  = "X-Content-Type-Options"
        header_value = "nosniff" # To add a response header set this property
      }
      # Referrer-Policy
      response_header_configuration {
        header_name  = "Referrer-Policy"
        header_value = "no-referrer" # To add a response header set this property
      }
      # X-Permitted-Cross-Domain-Policies - PEX-2786
      response_header_configuration {
        header_name  = "X-Permitted-Cross-Domain-Policies"
        header_value = "none" # To add a response header set this property
      }
      # X-Frame-Options - PEX-6610
      response_header_configuration {
        header_name  = "X-Frame-Options"
        header_value = "SAMEORIGIN" # To add a response header set this property
      }

      response_header_configuration {
        header_name  = local.cache_control_name
        header_value = local.cache_control_value # To add a response header set this property
      }

      response_header_configuration {
        header_name  = local.permissions_name
        header_value = local.permissions_value # To add a response header set this property
      }
    } # end rewrite_rule

    rewrite_rule { # add set separate for CSP
      name          = "Add-CSP"
      rule_sequence = 300 # each rule needs a sequence #

      response_header_configuration {
        header_name = "Content-Security-Policy"
        # default-src; form-action; base-uri; frame-src; frame-ancestors; object-src;
        header_value = local.csp_rootconfig_defaults
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # connect-src;
        header_value = local.csp_rootconfig_connect
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # script-src;
        header_value = local.csp_rootconfig_script
      }
      # 
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # style-src;
        header_value = local.csp_rootconfig_style
      }
      #
      response_header_configuration {
        header_name = "Content-Security-Policy"
        # img-src;
        header_value = local.csp_rootconfig_img
      }
      #
    } # end rewrite_rule
  }   # end rewrite_rule_set


  # end region: SSL certificate  


  /* PLACEHOLDER: save the agw_fe_ip for app service config (future state)
  output "agw_fe_ip" { 
    value = azurerm_application_gateway.agw.frontend_ip_configuration 
  }
  */
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.agwkvid.id # Referenced from azurerm_user_assigned_identity resource block
    ]
  }

  ##### For No Single SPA Experimentation - To be deleted after POC
  probe {
    name                                      = "registration-stg"
    interval                                  = "30"
    protocol                                  = "Https"
    path                                      = var.agw_monitor_probe_registration
    timeout                                   = "120"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = "true"
    match {
      status_code = ["200-399"]
    }
  }

  probe {
    name                                      = "b2cext-stg"
    interval                                  = "30"
    protocol                                  = "Https"
    path                                      = var.agw_monitor_probe_b2cext
    timeout                                   = "120"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = "true"
    match {
      status_code = ["200-399"]
      # gw will return 404 for '/' 
      # status_code       = ["200-399","404"]
    }
  }

  backend_address_pool {
    name = "registration-stg"
    # this needs to be the app service name, CANNOT use fqdn here since DNS will resolve back to the AGW 
    fqdns = ["${azurerm_app_service.registrationui-stg.name}.azurewebsites.net"]
  }

  backend_address_pool {
    name = "b2cext-stg"
    # this needs to be the app service name, CANNOT use fqdn here since DNS will resolve back to the AGW 
    fqdns = ["${azurerm_app_service.b2cext-stg.name}.azurewebsites.net"]
  }

  ssl_certificate {
    name                = "signin-embarkstd-stg-dot-ehr-com"
    key_vault_secret_id = data.azurerm_key_vault_certificate.pexcert-stg.secret_id
  }
  

  # registration
  # http (80) listener is only redirect
  http_listener {
    name                           = "registration-http-lstn-stg"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-http"
    protocol                       = "Http"
    host_name                      = "signin-embarkstd-stg.ehr.com"
  }
  redirect_configuration {
    name                 = "http-to-https-redirect-registration-stg"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "registration-https-lstn-stg"
  }
  request_routing_rule {
    name                        = "http-to-https-requests-registration-stg"
    rule_type                   = "Basic"
    http_listener_name          = "registration-http-lstn-stg"
    redirect_configuration_name = "http-to-https-redirect-registration-stg"
    rewrite_rule_set_name       = "headersecurity_registrationui" # reference for rewrite rule
  }
  # need listener https (443) for each request routing rule / FQDN (host_names), same SSL cert is used
  http_listener {
    name                           = "registration-https-lstn-stg"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-https"
    protocol                       = "Https"
    ssl_certificate_name           = "signin-embarkstd-stg-dot-ehr-com"
    host_name                      = "signin-embarkstd-stg.ehr.com"
  }
  backend_http_settings {
    name                                = "registration-stg"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 120
    host_name                           = "signin-embarkstd-stg.ehr.com"
    pick_host_name_from_backend_address = "false"
    probe_name                          = "registration-stg"
  }
  # Configure a routing rule to send traffic from a given frontend IP address to one or more backend targets. A routing rule must contain a listener and at least one backend target.
  request_routing_rule {
    name                       = "registration-rqrt-stg"
    rule_type                  = "Basic"
    http_listener_name         = "registration-https-lstn-stg"
    backend_address_pool_name  = "registration-stg"
    backend_http_settings_name = "registration-stg"
    rewrite_rule_set_name      = "headersecurity_registrationui" # reference for rewrite rule
  }

# B2C Ext 
  # PEX-3563 - DevOps - [Tech Debt] Azure GuardRails 100 - B2C extensions and SAML test
  # http (80) listener is only redirect
  http_listener {
    name                           = "b2cext-http-lstn-stg"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-http"
    protocol                       = "Http"
    host_name                      = "b2cext-embarkstd-stg.ehr.com"
  }
  redirect_configuration {
    name                 = "http-to-https-redirect-b2cext-stg"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "b2cext-https-lstn-stg"
  }
  request_routing_rule {
    name                        = "http-to-https-requests-b2cext-stg"
    rule_type                   = "Basic"
    http_listener_name          = "b2cext-http-lstn-stg"
    redirect_configuration_name = "http-to-https-redirect-b2cext-stg"
    rewrite_rule_set_name       = "headersecurity" # reference for rewrite rule
  }


  # need listener https (443) for each request routing rule / FQDN (host_names), same SSL cert is used
  http_listener {
    name                           = "b2cext-https-lstn-stg"
    frontend_ip_configuration_name = "${var.agw_name}-feip"
    frontend_port_name             = "${var.agw_name}-https"
    protocol                       = "Https"
    ssl_certificate_name           = "signin-embarkstd-stg-dot-ehr-com"
    host_name                      = "b2cext-embarkstd-stg.ehr.com"
  }
  backend_http_settings {
    name                                = "b2cext-stg"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 120
    host_name                           = "b2cext-embarkstd-stg.ehr.com"
    pick_host_name_from_backend_address = "false"
    probe_name                          = "b2cext-stg"
  }
  # Configure a routing rule to send traffic from a given frontend IP address to one or more backend targets. A routing rule must contain a listener and at least one backend target.
  request_routing_rule {
    name                       = "b2cext-rqrt-stg"
    rule_type                  = "Basic"
    http_listener_name         = "b2cext-https-lstn-stg"
    backend_address_pool_name  = "b2cext-stg"
    backend_http_settings_name = "b2cext-stg"
    rewrite_rule_set_name      = "headersecurity" # reference for rewrite rule
  }

}

# agw user assigned identity - this will be handled via script to add to KeyVault resource group instead
resource "azurerm_user_assigned_identity" "agwkvid" {
  # not sure why 'convention' name doesn't work.. using the random id instead
  # could be the 24 character KeyVault max name length
  # name               = "${azurerm_application_gateway.agw.name}-kvid"
  name                = "agwkvid-${random_id.agw.dec}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.appx_tags
}
