resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}


resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.rg_location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

storage_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
  version   = "latest"
}
  storage_os_disk {
    name              = var.os_disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile_linux_config {
    disable_password_authentication = false
    }
    
    os_profile {
      computer_name  = "hostname"
      admin_username = data.azurerm_key_vault_secret.username.value
      admin_password = data.azurerm_key_vault_secret.password.value
      custom_data = base64encode(<<EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install nginx -y
  sudo systemctl enable nginx
  sudo systemctl start nginx
  EOF
      )
    }
}
