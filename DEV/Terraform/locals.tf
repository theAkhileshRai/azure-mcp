# since these variables are re-used - a locals block makes this more maintainable
locals {
  regioncodeprefix = "${var.region_code}${var.productgroupcode}" # region code + 'pex' prefix to keep consistent

  ## DR vars ##
  # atm_resource_group_name = "trafficmanager-ptl-projectex-rgrp"
  # # ATM DNS names
  # atm_dns_dnn          = "embark-ehr-com"
  # atm_dns_gateway      = "embark-gw-ehr-com"
  # atm_dns_registration = "signin-embark-ehr-com"

  ## FQDN ##
  # assets_cdn_fqdn              = "n21pexassetsdevcdn.azureedge.net"
  # b2cext_fqdn                  = "n21pexb2cextnqaappsvc.azurewebsites.net"
  # cltadmin_fqdn                = "n21pexcltadmindevappsvc.azurewebsites.net"
  # frontui_fqdn                 = "n21pexfrontuidevappsvc.azurewebsites.net"
  # gateway_fqdn                 = "n21pexgatewaydevappsvc.azurewebsites.net"
  # registration_fqdn            = "n21pexregistrationuidevappsvc.azurewebsites.net"
  # rootconfigmicrofrontend_fqdn = "n21pexrootconfigmicrofrontenddevappsvc.azurewebsites.net"

  b2cext_fqdn                  = "b2cext-embark-dev.ehr.com"
  cltadmin_fqdn                = "clientadmin-embark-dev.ehr.com"
  frontui_fqdn                 = "n21pexfrontuidevappsvc.azurewebsites.net"
  gateway_fqdn                 = "embark-dev-gw.ehr.com"
  gateway_qa_fqdn              = "embark-qa-gw.ehr.com"
  registration_fqdn            = "signin-embark-dev.ehr.com"
  rootconfigmicrofrontend_fqdn = "embark-dev.ehr.com"
  samltest_fqdn                = "authtest-embark-dev.ehr.com"
  assets_cdn_fqdn              = "assets-embark-dev.ehr.com"
  microfrontend_cdn_fqdn       = "microfrontend-embark-dev.ehr.com"

  ## FQDN Integrations ##
  commonauth_fqdn = "auth-dev.ehr.com"
  b2clogin_fqdn   = "wtwb2cdev.b2clogin.com"
  ees_iap         = "qa-iap.towerswatson.com"
  ees_insight     = "qa-insight.willistowerswatson.com"
  oneembark_fqdn  = "embarkpro-devint.ehr.com"

  # PEX-2876 - CSP Headers for Registration UI
  # https://dev.azure.com/wtwdst/HRPortal/_workitems/edit/14821/ - Pen Test 2024 - embark.ehr.com - Low - Missing or Insecure Content-Security-Policy (CSP) Header
  # Remove unsafe-inline part on CSP 
  # With the 1000 limit, add {http_resp_Content-Security-Policy} on each new CSP header: https://github.com/MicrosoftDocs/azure-docs/issues/40132#issuecomment-1063057780
  csp_registration_defaults = "default-src 'self' https://*.content-cms.com/ 127.0.0.1; form-action 'self' https:; base-uri 'self'; frame-src 'self' https://www.recaptcha.net/ https://*.ehr.com/ https://*.wtwco.com https://poc.idscan.cloud/ 127.0.0.1; frame-ancestors 'self' https:; object-src 'self';"
  csp_registration_connect  = "{http_resp_Content-Security-Policy} connect-src 'self' https://dc.services.visualstudio.com/v2/track https://cdn.cookielaw.org/ https://geolocation.onetrust.com/ https://*.onetrust.com/ https://*.ehr.com https://*.willistowerswatson.com;"
  csp_registration_script   = "{http_resp_Content-Security-Policy} script-src 'self' 'unsafe-inline' https://*.ehr.com/ https://n21projectexdnndevstg.blob.core.windows.net/assets/js/ https://cdn.jsdelivr.net/npm/ https://ajax.googleapis.com/ajax/libs/ https://n21microfrontenddevstgsitecdn.azureedge.net/js/ https://cdn.cookielaw.org/scripttemplates/ https://cdn.cookielaw.org/consent/ https://fonts.googleapis.com/ https://www.recaptcha.net/ https://www.gstatic.com/recaptcha/ https://*.onetrust.com/ https://code.jquery.com/ https://www.sc.pages01.net/ https://www.sc.pages02.net/ https://www.sc.pages03.net/ https://www.sc.pages04.net/ https://www.sc.pages05.net/ https://www.sc.pages06.net/ https://www.sc.pages07.net/ https://www.sc.pages08.net/ https://www.sc.pages09.net/ https://www.sc.pagesA.net/;"
  csp_registration_style    = "{http_resp_Content-Security-Policy} style-src 'self' 'unsafe-inline' https://microfrontend-embark-dev.ehr.com/ https://assets-embark-dev.ehr.com/ https://n21microfrontenddevstgsitecdn.azureedge.net/css/ https://n21projectexdnndevstg.blob.core.windows.net/assets/ https://fonts.googleapis.com/ https://www.pages06.net/ https://*.onetrust.com/; font-src 'self' https://fonts.gstatic.com/ https://*.onetrust.com/;"
  csp_registration_img      = "{http_resp_Content-Security-Policy} img-src data: https:; media-src 'self' https://ssl.gstatic.com/"

  # PEX-8394 - Settlement Portal - Penetration Test - Insecure CSP header - Remove unsafe-inline for RegistrationUI Header

  csp_registration_script_nounsafeinline   = "{http_resp_Content-Security-Policy} script-src 'self' 'sha256-Rp2tldZXafi1I6Oi2Cls6zL5J3L6Na+6BAYrCENZMVg=' 'sha256-6wRdeNJzEHNIsDAMAdKbdVLWIqu8b6+Bs+xVNZqplQw=' https://*.ehr.com/ https://n21projectexdnndevstg.blob.core.windows.net/assets/js/ https://cdn.jsdelivr.net/npm/ https://ajax.googleapis.com/ajax/libs/ https://n21microfrontenddevstgsitecdn.azureedge.net/js/ https://cdn.cookielaw.org/scripttemplates/ https://cdn.cookielaw.org/consent/ https://fonts.googleapis.com/ https://www.recaptcha.net/ https://www.gstatic.com/recaptcha/ https://*.onetrust.com/ https://code.jquery.com/ https://www.sc.pages01.net/ https://www.sc.pages02.net/ https://www.sc.pages03.net/ https://www.sc.pages04.net/ https://www.sc.pages05.net/ https://www.sc.pages06.net/ https://www.sc.pages07.net/ https://www.sc.pages08.net/ https://www.sc.pages09.net/ https://www.sc.pagesA.net/;"
  csp_registration_style_nounsafeinline    = "{http_resp_Content-Security-Policy} style-src 'self' https://microfrontend-embark-dev.ehr.com/ https://assets-embark-dev.ehr.com/ https://n21microfrontenddevstgsitecdn.azureedge.net/css/ https://n21projectexdnndevstg.blob.core.windows.net/assets/ https://fonts.googleapis.com/ https://www.pages06.net/ https://*.onetrust.com/; font-src 'self' https://fonts.gstatic.com/ https://*.onetrust.com/;"

  # PEX-2876 - CSP Headers for Root Config
  csp_rootconfig_defaults = "default-src 'self' https://*.content-cms.com/ 127.0.0.1; form-action 'self' https:; base-uri 'self' https://*.ehr.com/ https://n21projectexdnndevstg.blob.core.windows.net/ https://n21microfrontenddevstgsitecdn.azureedge.net/; frame-src 'self' https: https://www.recaptcha.net/ 127.0.0.1; frame-ancestors 'self' https://*.ehr.com/; object-src 'self';"
  csp_rootconfig_connect  = "{http_resp_Content-Security-Policy} connect-src 'self' blob: localhost:* wss://embark-dev.ehr.com:*/ wss://*.intercom.io/ https://dc.services.visualstudio.com/v2/track https://cdn.cookielaw.org/ https://geolocation.onetrust.com/ https://*.onetrust.com/ https://*.ehr.com https://*.willistowerswatson.com  https://*.azurewebsites.net/ https://*.content-cms.com/ https://n21projectexdnndevstg.blob.core.windows.net/ https://n21microfrontenddevstgsitecdn.azureedge.net/ https://js.monitor.azure.com/ https://*.intercom.io/;"
  csp_rootconfig_script   = "{http_resp_Content-Security-Policy} script-src 'self' 'unsafe-inline' localhost:* https://n21microfrontenddevstgsitecdn.azureedge.net/ https://n21projectexdnndevstg.blob.core.windows.net/ https://*.azurewebsites.net/ https://cdn.jsdelivr.net/npm/ https://ajax.googleapis.com/ajax/libs/ https://cdn.cookielaw.org/ https://gstatic.com/ https://fonts.googleapis.com/ https://*.onetrust.com/ https://code.jquery.com/ https://*.content-cms.com/ https://ajax.aspnetcdn.com/ https://*.ehr.com/ https://www.sc.pages01.net/ https://www.sc.pages02.net/ https://www.sc.pages03.net/ https://www.sc.pages04.net/ https://www.sc.pages05.net/ https://www.sc.pages06.net/ https://www.sc.pages07.net/ https://www.sc.pages08.net/ https://www.sc.pages09.net/ https://www.sc.pagesA.net/ https://*.intercom.io/ https://js.intercomcdn.com/;"
  csp_rootconfig_script_cdn   = "{http_resp_Content-Security-Policy} script-src 'self' 'unsafe-inline' localhost:* https://*.ehr.com/ https://n21microfrontenddevstgsitecdn.azureedge.net/ https://n21projectexdnndevstg.blob.core.windows.net/ https://*.azurewebsites.net/ https://cdn.jsdelivr.net/npm/ https://ajax.googleapis.com/ajax/libs/ https://cdn.cookielaw.org/ https://gstatic.com/ https://fonts.googleapis.com/ https://*.onetrust.com/ https://code.jquery.com/ https://*.content-cms.com/ https://ajax.aspnetcdn.com/ https://*.ehr.com/;"
  csp_rootconfig_script_cdn2  = "{http_resp_Content-Security-Policy} script-src https://www.sc.pages01.net/ https://www.sc.pages02.net/ https://www.sc.pages03.net/ https://www.sc.pages04.net/ https://www.sc.pages05.net/ https://www.sc.pages06.net/ https://www.sc.pages07.net/ https://www.sc.pages08.net/ https://www.sc.pages09.net/ https://www.sc.pagesA.net/;"
  csp_rootconfig_style    = "{http_resp_Content-Security-Policy} style-src 'self' 'unsafe-inline' https://*.ehr.com/ https://n21microfrontenddevstgsitecdn.azureedge.net/ https://n21projectexdnndevstg.blob.core.windows.net/assets/ https://fonts.googleapis.com/ https://www.pages06.net/ https://*.onetrust.com/ https://ajax.aspnetcdn.com/; font-src 'self' https://*.ehr.com/ https://fonts.gstatic.com/ https://*.onetrust.com/ https://*.content-cms.com/ https://n21microfrontenddevstgsitecdn.azureedge.net/ https://fonts.intercomcdn.com/;"
  csp_rootconfig_img      = "{http_resp_Content-Security-Policy} img-src data: blob: https:;"

  # PEX-8394 - Pentest Items - Assets CDN

  csp_rootconfig_defaults_assets = "default-src 'self' https://*.content-cms.com/ 127.0.0.1; form-action 'self' https:; base-uri 'self' https://*.ehr.com/ https://n21projectexdnndevstg.blob.core.windows.net/ https://n21microfrontenddevstgsitecdn.azureedge.net/; frame-src 'self' https: https://www.recaptcha.net/ 127.0.0.1; frame-ancestors 'self' https://*.ehr.com/; object-src 'self';"
  csp_rootconfig_connect_assets  = "{http_resp_Content-Security-Policy} connect-src 'self' blob: localhost:* wss://embark-dev.ehr.com:*/ https://dc.services.visualstudio.com/v2/track https://cdn.cookielaw.org/ https://geolocation.onetrust.com/ https://*.onetrust.com/ https://*.ehr.com https://*.willistowerswatson.com  https://*.azurewebsites.net/ https://*.content-cms.com/ https://n21projectexdnndevstg.blob.core.windows.net/ https://n21microfrontenddevstgsitecdn.azureedge.net/ https://js.monitor.azure.com/ https://*.intercom.io/;"
  csp_rootconfig_script_assets   = "{http_resp_Content-Security-Policy} script-src 'self' localhost:* https://n21microfrontenddevstgsitecdn.azureedge.net/ https://n21projectexdnndevstg.blob.core.windows.net/ https://*.azurewebsites.net/ https://cdn.jsdelivr.net/npm/ https://ajax.googleapis.com/ajax/libs/ https://cdn.cookielaw.org/ https://gstatic.com/ https://fonts.googleapis.com/ https://*.onetrust.com/ https://code.jquery.com/ https://*.content-cms.com/ https://ajax.aspnetcdn.com/ https://*.ehr.com/ https://www.sc.pages01.net/ https://www.sc.pages02.net/ https://www.sc.pages03.net/ https://www.sc.pages04.net/ https://www.sc.pages05.net/ https://www.sc.pages06.net/ https://www.sc.pages07.net/ https://www.sc.pages08.net/ https://www.sc.pages09.net/ https://www.sc.pagesA.net/ https://*.intercom.io/ https://js.intercomcdn.com/;"
  csp_rootconfig_script_cdn_assets   = "{http_resp_Content-Security-Policy} script-src 'self' localhost:* https://*.ehr.com/ https://n21microfrontenddevstgsitecdn.azureedge.net/ https://n21projectexdnndevstg.blob.core.windows.net/ https://*.azurewebsites.net/ https://cdn.jsdelivr.net/npm/ https://ajax.googleapis.com/ajax/libs/ https://cdn.cookielaw.org/ https://gstatic.com/ https://fonts.googleapis.com/ https://*.onetrust.com/ https://code.jquery.com/ https://*.content-cms.com/ https://ajax.aspnetcdn.com/ https://*.ehr.com/;"
  csp_rootconfig_script_cdn2_assets  = "{http_resp_Content-Security-Policy} script-src https://www.sc.pages01.net/ https://www.sc.pages02.net/ https://www.sc.pages03.net/ https://www.sc.pages04.net/ https://www.sc.pages05.net/ https://www.sc.pages06.net/ https://www.sc.pages07.net/ https://www.sc.pages08.net/ https://www.sc.pages09.net/ https://www.sc.pagesA.net/;"
  csp_rootconfig_style_assets    = "{http_resp_Content-Security-Policy} style-src 'self' https://*.ehr.com/ https://n21microfrontenddevstgsitecdn.azureedge.net/ https://n21projectexdnndevstg.blob.core.windows.net/assets/ https://fonts.googleapis.com/ https://www.pages06.net/ https://*.onetrust.com/ https://ajax.aspnetcdn.com/; font-src 'self' https://*.ehr.com/ https://fonts.gstatic.com/ https://*.onetrust.com/ https://*.content-cms.com/ https://n21microfrontenddevstgsitecdn.azureedge.net/;"
  csp_rootconfig_img_assets      = "{http_resp_Content-Security-Policy} img-src data: blob: https:;"

  # PEX-5645/PEX-5643 - HSTS Scans
  header_name  = "Strict-Transport-Security"
  header_value = "max-age=31536000; includeSubDomains; preload"

  referrer_name  = "Referrer-Policy"
  referrer_value = "no-referrer"

  content_name  = "X-Content-Type-Options"
  content_value = "nosniff"

  frameoptions_name  = "X-Frame-Options"
  frameoptions_value = "SAMEORIGIN"

  # https://dev.azure.com/wtwdst/HRPortal/_workitems/edit/14823/ - Pen Test 2024 - embark.ehr.com - Low - Missing or Misconfigured Cache-Control HTTP Header

  cache_control_name  = "Cache-Control"
  cache_control_value = "no-cache"

  # https://dev.azure.com/wtwdst/HRPortal/_workitems/edit/17631/ - [DevOps] - Add permission policy header
  
  permissions_name  = "Permissions-Policy"
  permissions_value = "accelerometer=(),camera=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()"
  permissions_value_registration = "accelerometer=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()" # PEX-8592 - [Dev and QA] GBG Id Scan: Allow URL  for CSP to Signin-embark-<environment>.ehr.com and remove camera() from Permissions-Policy header

  # Centralise AppEx tags for reuse
  appx_tags = {
    "AppID"           = var.AppID
    "IAC"             = var.iac_tag
    "business"        = var.business
    "billingbusiness" = var.business
    "program"         = var.program
    "product"         = var.product
    "region"          = var.region
    "datacenter"      = var.region_code
    "hostingprovider" = var.hostingprovider
  }

    sa_tags = {
    "AppID"           = var.SAAppID
    "IAC"             = var.iac_tag
    "business"        = var.business
    "billingbusiness" = var.business
    "program"         = var.SAprogram
    "product"         = var.SAproduct
    "region"          = var.region
    "datacenter"      = var.region_code
    "hostingprovider" = var.hostingprovider
  }

  assets_cors = [
    "https://${local.rootconfigmicrofrontend_fqdn}",
    "https://${local.registration_fqdn}",
    "https://${local.gateway_fqdn}",
    "https://${local.b2clogin_fqdn}",
    "https://${local.commonauth_fqdn}"
  ]

  cltadmin_cors = [
    "https://${local.cltadmin_fqdn}"
  ]

  # gateway_cors = [
  #   "https://${local.rootconfigmicrofrontend_fqdn}",
  #   "https://${local.registration_fqdn}",
  #   "https://${local.gateway_fqdn}",
  #   "https://${local.regioncodeprefix}assets${var.env_code}stg.blob.core.windows.net",
  #   "https://${var.region_code}projectexdnn${var.env_code}stg.blob.core.windows.net/assets",
  #   "https://${local.b2clogin_fqdn}",
  #   "https://${local.frontui_fqdn}",
  #   "https://${local.commonauth_fqdn}"
  # ]

  gateway_cors = [
    "https://${local.rootconfigmicrofrontend_fqdn}", # PEX-4090 - Add embark3 to Gateway CORS
    "https://${local.registration_fqdn}",
    "https://${local.gateway_fqdn}",
    "https://${local.cltadmin_fqdn}",
    "https://${local.b2clogin_fqdn}",
    "https://${local.frontui_fqdn}",
    "https://${local.assets_cdn_fqdn}",
    "https://${local.microfrontend_cdn_fqdn}",
    "https://${local.commonauth_fqdn}",
    "https://${local.ees_iap}",
    "https://${local.ees_insight}",
    "http://localhost:9000",
    "https://localhost:5100", # Allow One Place Auth
    "https://${local.regioncodeprefix}assets${var.env_code}stg.blob.core.windows.net",
    "https://${local.regioncodeprefix}projectexdnn${var.env_code}stg.blob.core.windows.net",
    "https://${local.regioncodeprefix}gateway${var.env_code}appsvc.azurewebsites.net",
    "https://${local.regioncodeprefix}configurationrootconfigmicrofrontend${var.env_code}appsvc.azurewebsites.net",
    "https://${local.regioncodeprefix}rootconfigmicrofrontend${var.env_code}appsvc.azurewebsites.net",
    "https://${local.oneembark_fqdn}",
    "https://${local.gateway_qa_fqdn}",
    "https://standard.traefik.me", # Local environment
    "https://embarkstd-dev.ehr.com", "https://signin-embarkstd-stg.ehr.com" # Sandbox. Can be removed once the sandbox is decommissioned
  ]

  # rootconfig_cors = [
  #   "https://${local.rootconfigmicrofrontend_fqdn}" ## PEX-4074 PEX-4090 - Add embark3 to CORS
  # ]

  rootconfig_cors = [
    "https://${local.rootconfigmicrofrontend_fqdn}",                                                   ## PEX-4074 PEX-4090 - Add embark3 to CORS
    "https://${local.regioncodeprefix}rootconfigmicrofrontend${var.env_code}appsvc.azurewebsites.net", # PEX-4074 - Add rootconfigmicrofrontend to CORS of embark3                                                     # PEX-4090 - Add embark3 to CORS
    "https://localhost:4200",
    "https://${local.gateway_qa_fqdn}"                                                                        # Allows engineers to use RootConfig QA to reference any Widget MicroFrontend from local - for debugging purposes only
  ]

  signalr_cors = [
    "https://embark-qa.ehr.com" ## PEX-4074 PEX-4090 - Add embark3 to CORS / Temporary entry for GR 278
  ]
}
