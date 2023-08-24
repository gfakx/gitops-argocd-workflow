variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual machine."
}
variable "location" {
  description = "The Azure region where all resources should be created."
  default     = "Canadacentral"
}
variable "vm_name" {
  description = "The name of the virtual machine."
  default     = "myVM"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "The name of the administrative account."
  default     = "adminuser"
}
# Uncheck if you are using password to login
#variable "admin_password" {
#  description = "The password of the administrative account."
#  sensitive   = true
#}

variable "os_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machine."
  default     = "Canonical"
}

variable "os_offer" {
  description = "Specifies the offer of the image used to create the virtual machine."
  default     = "UbuntuServer"
}

variable "os_sku" {
  description = "Specifies the SKU of the image used to create the virtual machine."
  default     = "18.04-LTS"
}

variable "os_version" {
  description = "Specifies the version of the image used to create the virtual machine."
  default     = "latest"
}
variable "ssh_public_key_path" {
  description = "Path to the public SSH key."
  type        = string
}
