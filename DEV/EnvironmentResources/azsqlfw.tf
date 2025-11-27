/*
# Global Azure SQL firewallrules
VNET (optional) - must have separate service connection to the RGRP the VNET is a member of
Firewall rules are as follows:
01 - 10: Allow WTW egress IPs (public, vpn, etc.) 
*/

resource "azurerm_mssql_firewall_rule" "fw01" {
  name             = "APACMicrosoftPublicPAT-PRI"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "32.66.102.170"
  end_ip_address   = "32.66.102.174"
}

resource "azurerm_mssql_firewall_rule" "fw02" {
  name             = "EMEAMicrosoftPublicPAT-PRI"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "32.66.114.161"
  end_ip_address   = "32.66.114.165"
}

resource "azurerm_mssql_firewall_rule" "fw03" {
  name             = "NALAMicrosoftPublicPAT-PRI"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "32.65.74.146"
  end_ip_address   = "32.65.74.150"
}

resource "azurerm_mssql_firewall_rule" "fw04" {
  name             = "CiscoASAAmericas-East"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "158.82.143.130"
  end_ip_address   = "158.82.143.130"
}

resource "azurerm_mssql_firewall_rule" "fw05" {
  name             = "CiscoASAAmericas-West"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "158.82.159.130"
  end_ip_address   = "158.82.159.130"
}

resource "azurerm_mssql_firewall_rule" "fw06" {
  name             = "CiscoASAAPAC-HongKong"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "202.167.233.229"
  end_ip_address   = "202.167.233.229"
}

resource "azurerm_mssql_firewall_rule" "fw07" {
  name             = "CiscoASAAPAC-Singapore"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "27.111.213.117"
  end_ip_address   = "27.111.213.117"
}

resource "azurerm_mssql_firewall_rule" "fw08" {
  name             = "CiscoASAEMEA-SouthAfrica"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "41.242.168.121"
  end_ip_address   = "41.242.168.121"
}

resource "azurerm_mssql_firewall_rule" "fw09" {
  name             = "EM1-Reigate-UK-1"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "62.172.72.84"
  end_ip_address   = "62.172.72.84"
}

resource "azurerm_mssql_firewall_rule" "fw10" {
  name             = "EM1-Reigate-UK-2"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "62.172.72.131"
  end_ip_address   = "62.172.72.131"
}

resource "azurerm_mssql_firewall_rule" "fw11" {
  name             = "EM1-Reigate-UK-EM11-EFW-1"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "89.28.187.5"
  end_ip_address   = "89.28.187.5"
}

resource "azurerm_mssql_firewall_rule" "fw12" {
  name             = "EM1-Reigate-UK-EM11-EFW-2"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "89.28.187.6"
  end_ip_address   = "89.28.187.6"
}

resource "azurerm_mssql_firewall_rule" "fw13" {
  name             = "EM1-Reigate-UK-EM11-EFW-3"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "89.28.187.7"
  end_ip_address   = "89.28.187.7"
}

resource "azurerm_mssql_firewall_rule" "fw14" {
  name             = "EM1-Reigate-UK-EM11-EFW-4"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "89.28.187.8"
  end_ip_address   = "89.28.187.8"
}

resource "azurerm_mssql_firewall_rule" "fw15" {
  name             = "EM1-Reigate-UK-EM11-EFW-5"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "89.28.187.9"
  end_ip_address   = "89.28.187.9"
}

resource "azurerm_mssql_firewall_rule" "fw16" {
  name             = "EM1-Reigate-UK-EM11-EFW-6"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "89.28.187.10"
  end_ip_address   = "89.28.187.10"
}

resource "azurerm_mssql_firewall_rule" "fw17" {
  name             = "EM1-Reigate-UK-EM11-EFW-7"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "89.28.187.11"
  end_ip_address   = "89.28.187.11"
}

resource "azurerm_mssql_firewall_rule" "fw18" {
  name             = "EM1-Reigate-UK-EM11-EFW-8"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "89.28.187.12"
  end_ip_address   = "89.28.187.12"
}

resource "azurerm_mssql_firewall_rule" "fw19" {
  name             = "NA11NashvilleDMZEgresIP-PAT"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "158.82.143.120"
  end_ip_address   = "158.82.143.120"
}

resource "azurerm_mssql_firewall_rule" "f20" {
  name             = "NA12IrvingDMZEgressIP-PAT"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "158.82.159.120"
  end_ip_address   = "158.82.159.120"
}

resource "azurerm_mssql_firewall_rule" "f21" {
  name             = "TempEgressMBRA002D"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "104.43.166.127"
  end_ip_address   = "104.43.166.127"
}
resource "azurerm_mssql_firewall_rule" "f22" {
  name             = "TempEgressMBRA001Q"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "40.78.156.126"
  end_ip_address   = "40.78.156.126"
}
resource "azurerm_mssql_firewall_rule" "f23" {
  name             = "TempEgressMBRA002Q"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "23.99.177.77"
  end_ip_address   = "23.99.177.77"
}
# CXP
resource "azurerm_mssql_firewall_rule" "fwcxp" {
  name             = "CXP"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "158.82.1.0"
  end_ip_address   = "158.82.1.255"
}
#Azure DevOps VMSS Agent
resource "azurerm_mssql_firewall_rule" "vmss" {
  name             = "AZDO VMSS"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "52.142.93.7"
  end_ip_address   = "52.142.93.7"
}
#Bedrock VNets
resource "azurerm_mssql_virtual_network_rule" "bedrock-subnets" {
  for_each  = { for k in toset(var.bedrock_subnet_ids) : k => k }
  name      = sha1(each.key)
  server_id = azurerm_mssql_server.sqlserver.id
  subnet_id = each.key
}
#Bedrock DR IP
resource "azurerm_mssql_firewall_rule" "bedrock-ip" {
  name             = "Bedrock DR IP"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = var.bedrock_dr_ip
  end_ip_address   = var.bedrock_dr_ip
}