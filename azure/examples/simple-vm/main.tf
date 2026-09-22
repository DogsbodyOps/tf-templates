provider "azurerm" {
  features {}
}

variable "admin_username" {
  type = string
}

variable "public_key" {
  type      = string
  sensitive = true
}

variable "allowed_ssh_ips" {
  type = list(string)
}

resource "azurerm_resource_group" "this" {
  name     = "my-project-rg"
  location = "uksouth"
}

module "vm" {
  source = "git::https://github.com/your-org/tf-templates-azure.git//modules/simple-vm?ref=main"

  name                = "my-project"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  admin_username      = var.admin_username
  public_key          = var.public_key
  allowed_ssh_ips     = var.allowed_ssh_ips
}

output "ssh" {
  value = module.vm.ssh_command
}
