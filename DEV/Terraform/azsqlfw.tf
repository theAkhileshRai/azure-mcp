/*
# Global Azure SQL firewallrules
VNET (optional) - must have separate service connection to the RGRP the VNET is a member of
Firewall rules are as follows:
00: Allow Azure Services
01 - 10: Allow WTW egress IPs (public, vpn, etc.) 
*/


# allow Azure Services
# see: https://docs.microsoft.com/en-us/rest/api/sql/firewallrules/createorupdate

/* # Handled Firewall Rules Thru Script
resource "azurerm_sql_firewall_rule" "fw00" {
  name                = "Allow Azure Services"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "fw01" {
  name                = "APACMicrosoftPublicPAT-PRI"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "32.66.102.170"
  end_ip_address      = "32.66.102.174"
}

resource "azurerm_sql_firewall_rule" "fw02" {
  name                = "EMEAMicrosoftPublicPAT-PRI"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "32.66.114.161"
  end_ip_address      = "32.66.114.165"
}

resource "azurerm_sql_firewall_rule" "fw03" {
  name                = "NALAMicrosoftPublicPAT-PRI"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "32.65.74.146"
  end_ip_address      = "32.65.74.150"
}

resource "azurerm_sql_firewall_rule" "fw04" {
  name                = "CiscoASAAmericas-East"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "158.82.143.130"
  end_ip_address      = "158.82.143.130"
}

resource "azurerm_sql_firewall_rule" "fw05" {
  name                = "CiscoASAAmericas-West"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "158.82.159.130"
  end_ip_address      = "158.82.159.130"
}

resource "azurerm_sql_firewall_rule" "fw06" {
  name                = "CiscoASAAPAC-HongKong"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "202.167.233.229"
  end_ip_address      = "202.167.233.229"
}

resource "azurerm_sql_firewall_rule" "fw07" {
  name                = "CiscoASAAPAC-Singapore"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "27.111.213.117"
  end_ip_address      = "27.111.213.117"
}

resource "azurerm_sql_firewall_rule" "fw08" {
  name                = "CiscoASAEMEA-SouthAfrica"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "41.242.168.121"
  end_ip_address      = "41.242.168.121"
}

resource "azurerm_sql_firewall_rule" "fw09" {
  name                = "EM1-Reigate-UK-1"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "62.172.72.84"
  end_ip_address      = "62.172.72.84"
}

resource "azurerm_sql_firewall_rule" "fw10" {
  name                = "EM1-Reigate-UK-2"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "62.172.72.131"
  end_ip_address      = "62.172.72.131"
}

resource "azurerm_sql_firewall_rule" "fw11" {
  name                = "EM1-Reigate-UK-EM11-EFW-1"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "89.28.187.5"
  end_ip_address      = "89.28.187.12"
}

resource "azurerm_sql_firewall_rule" "fw19" {
  name                = "NA11NashvilleDMZEgresIP-PAT"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "158.82.143.120"
  end_ip_address      = "158.82.143.120"
}

resource "azurerm_sql_firewall_rule" "f20" {
  name                = "NA12IrvingDMZEgressIP-PAT"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "158.82.159.120"
  end_ip_address      = "158.82.159.120"
}

resource "azurerm_sql_firewall_rule" "f21" {
  name                = "CXP"
  resource_group_name = "__resource_group_name__"
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "158.82.1.0"
  end_ip_address      = "158.82.1.47"
}

*/