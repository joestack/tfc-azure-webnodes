# Configure the Azure Provider
provider "azurerm" {
  features {}

  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  #version = "=1.36.0"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = "West US 2"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["${var.network_address_space}"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.network_address_space, 8, 1),]
}

resource "azurerm_network_interface" "main" {
  count               = var.web_node_count
  name                = format("${var.prefix}-nic-%02d", count.index +1)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}


### bastion host
####

resource "azurerm_public_ip" "example" {
  count               = var.web_node_count
  name                = format("publicip-%02d", count.index + 1)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


###### NEW webnode workers

resource "azurerm_linux_virtual_machine" "main" {
  count                 = var.web_node_count
  name                  = format("${var.prefix}-%02d", count.index + 1)
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "ubuntu"
  network_interface_ids = [
    element(azurerm_network_interface.main.*.id, count.index +1),
  ]
  #delete_os_disk_on_termination = true
  #delete_data_disks_on_termination = true

  ip_configuration {
    name                 = format("configuration-%02d", count.index + 1)
    subnet_id            = azurerm_subnet.main.id
    public_ip_address_id = azurerm_public_ip.example.id
  }

  admin_ssh_key {
    username   = "ubuntu"
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}


###### OLD
#resource "azurerm_virtual_machine" "main" {
#  count                 = var.web_node_count
#  name                  = format("${var.prefix}-%02d", count.index + 1)
#  location              = azurerm_resource_group.main.location
#  resource_group_name   = azurerm_resource_group.main.name
#  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index +1)]
#  vm_size               = "Standard_DS1_v2"
#
#  # Uncomment this line to delete the OS disk automatically when deleting the VM
#  delete_os_disk_on_termination = true
#
#  # Uncomment this line to delete the data disks automatically when deleting the VM
#  delete_data_disks_on_termination = true
#
#  storage_image_reference {
#    publisher = "Canonical"
#    offer     = "UbuntuServer"
#    sku       = "16.04-LTS"
#    version   = "latest"
#  }
#  storage_os_disk {
#    name              = format("${var.prefix}-disk-%02d", count.index + 1)
#    caching           = "ReadWrite"
#    create_option     = "FromImage"
#    managed_disk_type = "Standard_LRS"
#  }
#  os_profile {
#    computer_name  = format("${var.prefix}-%02d", count.index + 1)
#    admin_username = var.admin_username
#    admin_password = var.admin_password
#  }
#  os_profile_linux_config {
#    disable_password_authentication = false
#  }
#  tags = {
#    environment = "staging"
#  }
#}
