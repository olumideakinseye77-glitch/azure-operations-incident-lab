locals {
  location = "uksouth"
  tags = {
    Project     = "operations-incident-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
    Owner       = "Olu"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-olu-operations-lab"
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-olu-operations"
  address_space       = ["10.50.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_subnet" "main" {
  name                 = "snet-linux"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.50.1.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "nsg-olu-operations"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}
