# Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "Lab5"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "cheng-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet 1
resource "azurerm_subnet" "public_subnet" {
  name                 = "cheng_pub_sub"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.10.0/24"]
}

# Subnet 2
resource "azurerm_subnet" "private_subnet" {
  name                 = "cheng_pri_sub"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.20.0/24"]
}