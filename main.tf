module "vm" {
  source              = "./vm"
  location            = var.location
  resource_group_name = var.vm_resource_group_name
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  #  admin_password      = var.admin_password
  os_publisher        = var.os_publisher
  os_offer            = var.os_offer
  os_sku              = var.os_sku
  os_version          = var.os_version
  ssh_public_key_path = var.ssh_public_key_path
}
