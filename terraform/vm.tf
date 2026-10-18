resource "azurerm_public_ip" "main" {
  name                = "pip-olu-operations"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_network_interface" "main" {
  name                = "nic-olu-operations"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "vm-olu-operations"
  location                        = local.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = "Standard_D2s_v6"
  admin_username                  = "oluadmin"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.main.id]
  tags                            = local.tags

  admin_ssh_key {
    username   = "oluadmin"
    public_key = file(pathexpand("~/.ssh/olu-operations-lab.pub"))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.main
  ]
}

output "vm_public_ip" {
  value = azurerm_public_ip.main.ip_address
}
