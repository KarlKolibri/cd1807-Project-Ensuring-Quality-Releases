resource "azurerm_network_interface" "test" {
  name                = "nic-1"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip
  }
}



resource "azurerm_linux_virtual_machine" "ubuntu-vm" {
  name                = "ubuntu18vm"
  location            = var.location
  resource_group_name = var.resource_group
  size                = "Standard_B1s"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
    }
  
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.test.id]


  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}