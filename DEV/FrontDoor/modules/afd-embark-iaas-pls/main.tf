data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.vnet_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

resource "azurerm_lb" "lb" {
  name                = var.load_balancer_name
  location            = var.dnn_region
  resource_group_name = var.vm_resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name      = "fip"
    subnet_id = data.azurerm_subnet.subnet.id
  }

  tags = merge({}, var.default_tags)

  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"]]
  }
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.load_balancer_name}-probe"
  port                = 443
  interval_in_seconds = 15
}

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "${var.load_balancer_name}-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "fip"
  probe_id                       = azurerm_lb_probe.probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.beap.id]
}

resource "azurerm_lb_backend_address_pool" "beap" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "beap"
}

resource "azurerm_network_interface_backend_address_pool_association" "backend-address" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.beap.id
  network_interface_id    = var.vm_ip_info.nic_id
  ip_configuration_name   = var.vm_ip_info.ip_config_name
}

resource "azurerm_private_link_service" "privatelink" {
  name                = "${var.load_balancer_name}-pls"
  resource_group_name = var.vm_resource_group_name
  location            = var.dnn_region

  auto_approval_subscription_ids              = [var.subscription_id, "c1bc5dd7-ea97-469c-89fa-8f26624902fd"]
  visibility_subscription_ids                 = [var.subscription_id, "c1bc5dd7-ea97-469c-89fa-8f26624902fd"]
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.lb.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name                       = "primary"
    private_ip_address_version = "IPv4"
    subnet_id                  = data.azurerm_subnet.subnet.id
    primary                    = true
  }

  nat_ip_configuration {
    name                       = "secondary"
    private_ip_address_version = "IPv4"
    subnet_id                  = data.azurerm_subnet.subnet.id
    primary                    = false
  }

  tags = merge({}, var.default_tags)

  lifecycle {
    ignore_changes = [tags["business"], tags["billingbusiness"], tags["datacenter"], tags["hostingprovider"], tags["product"], tags["program"], tags["region"], nat_ip_configuration.0.subnet_id, nat_ip_configuration.1.subnet_id]
  }
}