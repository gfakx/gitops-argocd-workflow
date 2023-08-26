resource "azurerm_resource_group" "vm_rg" {
  name     = var.resource_group_name
  location = var.location

}

resource "azurerm_virtual_network" "gf_vnet" {
  depends_on = [azurerm_resource_group.vm_rg]
  name                = "gfakx_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "gf_subnet" {
  name                 = "vm-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.gf_vnet.name
  address_prefixes       = ["10.0.1.0/24"]
}



#This NSG will allow inbound SSH (port 22) and ICMP (ping) traffic:
resource "azurerm_network_security_group" "gf_nsg" {
  depends_on = [azurerm_resource_group.vm_rg]
  name                = "vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
#security_rule {
#    name                       = "SSH"
#    priority                   = 1012
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_range     = "8080"
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#  }
  security_rule {
    name                       = "ICMP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "gfakx_association" {
  subnet_id                 = azurerm_subnet.gf_subnet.id
  network_security_group_id = azurerm_network_security_group.gf_nsg.id
}

#This creates a network interface and associates it with the subnet and NSG:
resource "azurerm_public_ip" "pip" {
  depends_on = [azurerm_resource_group.vm_rg]
  name                = "my-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  }

resource "azurerm_network_interface" "gfakx_nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "vm-nic-config"
    subnet_id                     = azurerm_subnet.gf_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}


resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  vm_size               = var.vm_size
  network_interface_ids = [azurerm_network_interface.gfakx_nic.id]

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
#    admin_password = var.admin_password
  }

  os_profile_linux_config {
  disable_password_authentication = true
  ssh_keys {
    path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    key_data = file(var.ssh_public_key_path)
  }
}

  #   # Using username and password
  #  os_profile {
  #    computer_name  = var.vm_name
  #    admin_username = var.admin_username
  #    admin_password = var.admin_password
  #  }
  #
  #  os_profile_linux_config {
  #    disable_password_authentication = false
  #  }


  tags = {
    environment = "Production"
  }
}
